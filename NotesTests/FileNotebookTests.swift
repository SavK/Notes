import XCTest
@testable import Notes

class FileNotebookTests: XCTestCase {
    
    var fileNotebook: FileNotebook!

    override func setUp() {
        super.setUp()
        fileNotebook = FileNotebook(notes: [Note]())
    }

    override func tearDown() {
        fileNotebook = nil
        super.tearDown()
    }

    func testFileNotebook_isClass() {
        guard let fileNotebook = fileNotebook,
            let displayStyle = Mirror(reflecting: fileNotebook).displayStyle else {
            XCTFail()
            return
        }

        XCTAssertEqual(displayStyle, .class)
    }

    func testFileNotebook_whenInitialized_notesIsEmpty() {
        XCTAssertTrue(fileNotebook.notes.isEmpty)
    }

    func testFileNotebook_whenAddNote_noteSavedInNotes() {
        let note = Note(title: "Title",
                        content: "Text",
                        importance: .normal)
        
        fileNotebook.add(note)

        let notes = fileNotebook.notes

        XCTAssertEqual(notes.count, 1)

        let checkedNote = getNote(by: note.uid, from: notes)

        XCTAssertNotNil(checkedNote)
    }

    func testFileNotebook_whenAddNote_noteSavedInNotesWithAllInfo() {
        let note = Note(title: "Title", content: "Text", importance: .normal)
        fileNotebook.add(note)

        guard let checkedNote = getNote(by: note.uid, from: fileNotebook.notes) else {
            XCTFail()
            return
        }

        XCTAssertEqual(note.uid, checkedNote.uid)
        XCTAssertEqual(note.title, checkedNote.title)
        XCTAssertEqual(note.content, checkedNote.content)
        XCTAssertEqual(note.importance, checkedNote.importance)
        XCTAssertEqual(note.color, checkedNote.color)

        XCTAssertNil(note.selfDestructionDate)
        XCTAssertNil(checkedNote.selfDestructionDate)
    }

    func testFileNotebook_whenDeleteNote_noteRemoveFromNotes() {
        let note = Note(title: "Title",
                        content: "Text",
                        importance: .normal)
        
        fileNotebook.add(note)
        fileNotebook.remove(with: note.uid)

        let notes = fileNotebook.notes

        XCTAssertTrue(notes.isEmpty)
    }

    func testFileNotebook_whenSaveToFileAndLoadFromFile_correctRestoreNotes() {
        let note = Note(title: "Title",
                        content: "Text",
                        importance: .normal)
        fileNotebook.add(note)

        let note2 = Note(title: "New Title",
                         content: "My new text",
                         importance: .important,
                         color: .red,
                         selfDestructionDate: Date())
        fileNotebook.add(note2)

        fileNotebook.saveToFile()

        fileNotebook.remove(with: note.uid)
        fileNotebook.remove(with: note2.uid)

        XCTAssertTrue(fileNotebook.notes.isEmpty)

        let note3 = Note(title: "New Title3",
                         content: "My new text3",
                         importance: .unimportant,
                         color: .green,
                         selfDestructionDate: Date())
        fileNotebook.add(note3)

        fileNotebook.loadFromFile()

        let notes = fileNotebook.notes
        XCTAssertEqual(notes.count, 2)
        XCTAssertNotNil(getNote(by: note.uid, from: notes))
        XCTAssertNotNil(getNote(by: note2.uid, from: notes))
    }

    func testFileNotebook_whenSaveToFileAndLoadFromFile_equalsRestoredNotes() {
        let note = Note(title: "Title",
                        content: "Text",
                        importance: .normal)
        fileNotebook.add(note)

        let note2 = Note(title: "New Title",
                         content: "My new text",
                         importance: .important,
                         color: .red,
                         selfDestructionDate: Date())
        fileNotebook.add(note2)

        fileNotebook.saveToFile()
        fileNotebook.loadFromFile()

        let notes = fileNotebook.notes

        guard let checkedNote = getNote(by: note.uid, from: notes),
            let checkedNote2 = getNote(by: note2.uid, from: notes) else {
                XCTFail()
                return
        }

        XCTAssertEqual(note.uid, checkedNote.uid)
        XCTAssertEqual(note.title, checkedNote.title)
        XCTAssertEqual(note.content, checkedNote.content)
        XCTAssertEqual(note.importance, checkedNote.importance)
        XCTAssertEqual(note.color, checkedNote.color)

        XCTAssertNil(checkedNote.selfDestructionDate)

        guard let checkedDate = checkedNote.selfDestructionDate,
            let date = note.selfDestructionDate else {
            return
        }

        XCTAssertEqual(checkedDate, date)

        XCTAssertEqual(note2.uid, checkedNote2.uid)
        XCTAssertEqual(note2.title, checkedNote2.title)
        XCTAssertEqual(note2.content, checkedNote2.content)
        XCTAssertEqual(note2.importance, checkedNote2.importance)
        XCTAssertEqual(note2.color, checkedNote2.color)

        XCTAssertNotNil(checkedNote.selfDestructionDate)

        guard let checkedDate2 = checkedNote2.selfDestructionDate,
            let date2 = note2.selfDestructionDate else {
            return
        }
        XCTAssertEqual(checkedDate2, date2)
    }


    private func getNote(by uid: String, from notes:Any) -> Note? {
        if let notes = notes as? [String: Note] {
            return notes[uid]
        }

        if let notes = notes as? [Note] {
            return notes.filter { $0.uid == uid }.first
        }

        return nil
    }
}
