import XCTest
@testable import Notes

class FileNotebookTests: XCTestCase {
    
    var fileNotebook: FileNotebook!

    override func setUp() {
        super.setUp()
        fileNotebook = FileNotebook()
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
        
        fileNotebook.add(note: note)

        let notes = fileNotebook.notes

        XCTAssertEqual(notes.count, 1)

        let checkedNote = getNote(by: note.uid, from: notes)

        XCTAssertNotNil(checkedNote)
    }

    func testFileNotebook_whenAddNote_noteSavedInNotesWithAllInfo() {
        let note = Note(title: "Title", content: "Text", importance: .normal)
        fileNotebook.add(note: note)

        guard let checkedNote = getNote(by: note.uid, from: fileNotebook.notes) else {
            XCTFail()
            return
        }

        XCTAssertEqual(note.uid, checkedNote.uid)
        XCTAssertEqual(note.title, checkedNote.title)
        XCTAssertEqual(note.content, checkedNote.content)
        XCTAssertEqual(note.importance, checkedNote.importance)
        XCTAssertEqual(note.color.currentColor, checkedNote.color.currentColor)

        XCTAssertNil(note.selfDestructionDate)
        XCTAssertNil(checkedNote.selfDestructionDate)
    }

    func testFileNotebook_whenDeleteNote_noteRemoveFromNotes() {
        let note = Note(title: "Title",
                        content: "Text",
                        importance: .normal)
        
        fileNotebook.add(note: note)
        fileNotebook.remove(noteWith: note.uid)

        let notes = fileNotebook.notes

        XCTAssertTrue(notes.isEmpty)
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
