import XCTest
@testable import Notes

class NoteExtensionTests: XCTestCase {
    
    var noteMock: Note!
    
    override func setUp() {
        super.setUp()
        noteMock = Note(title: "Title",
                        content: "text",
                        importance: .important)
    }
    
    override func tearDown() {
        noteMock = nil
        super.tearDown()
    }
    
    func testNoteExtensions_whenParseEmptyDict_isOptionalNote() {
        let note = Note.parse(json: [:])
        
        XCTAssertNil(note)
    }
    
    func testNoteExtensions_whenGetJson_dictIsNotEmpty() {
        let json = noteMock.json
        
        XCTAssertFalse(json.isEmpty)
    }
    
    func testNoteExtensions_whenGetJsonWithWhiteColor_hasNotSaveColor() {
        let note = Note(title: "Text",
                        content: "More",
                        importance: .important,
                        color: .red)
        let json = note.json
        let jsonWithoutColor = noteMock.json
        
        XCTAssertTrue(json.count > jsonWithoutColor.count)
    }
    
    func testNoteExtensions_whenGetJsonWithNormalImportant_hasNotSaveImportant() {
        let note = Note(title: "Text",
                        content: "More",
                        importance: .normal)
        let json = noteMock.json
        let jsonWithoutImportant = note.json
        
        XCTAssertTrue(json.count > jsonWithoutImportant.count)
    }
    
    func testNoteExtensions_whenGetJsonWithoutDate_hasNotSaveDate() {
        let note = Note(title: "Text",
                        content: "More",
                        importance: .important,
                        selfDestructionDate: Date())
        let json = note.json
        let jsonWithoutDate = noteMock.json
        
        XCTAssertTrue(json.count > jsonWithoutDate.count)
    }
    
    func testNoteExtensions_whenGetJsonAndParseJson_isNote() {
        let note = getNoteThroughJsonFrom(noteMock)
        
        XCTAssertNotNil(note)
    }
    
    func testNoteExtensions_whenGetJsonAndParseJson_isEqualsNotes() {
        let _note = getNoteThroughJsonFrom(noteMock)
        
        guard let note = _note else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(noteMock.uid, note.uid)
        XCTAssertEqual(noteMock.title, note.title)
        XCTAssertEqual(noteMock.content, note.content)
        XCTAssertEqual(noteMock.importance, note.importance)
        XCTAssertEqual(noteMock.color, note.color)
        
        XCTAssertNil(noteMock.selfDestructionDate)
        XCTAssertNil(note.selfDestructionDate)
    }
    
    func testNoteExtensions_whenGetJsonAndParseJsonForFullNote_isEqualsNotes() {
        let originNote = Note(title: "Title1",
                              content: "My text",
                              importance: .unimportant,
                              color: .red,
                              selfDestructionDate: Date(),
                              uid: "1234")
        let _note = getNoteThroughJsonFrom(originNote)
        
        guard let note = _note else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(originNote.uid, note.uid)
        XCTAssertEqual(originNote.title, note.title)
        XCTAssertEqual(originNote.content, note.content)
        XCTAssertEqual(originNote.importance, note.importance)
        XCTAssertEqual(originNote.color, note.color)
        
        guard let originDate = originNote.selfDestructionDate,
            let date = note.selfDestructionDate else {
                XCTFail()
                return
        }
        XCTAssertEqual(originDate, date)
    }
    
    private func getNoteThroughJsonFrom(_ note: Note) -> Note? {
        print(note.json)
        print(Note.parse(json: note.json)!)
        return Note.parse(json: note.json)
    }
}
