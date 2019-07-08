import XCTest
@testable import Notes

class NoteTests: XCTestCase {
    
    private let uid = "123"
    private let title = "title"
    private let content = "text"
    private let importance = Importance.normal
    private var noteMock: Note!
    
    override func setUp() {
        super.setUp()
        noteMock = Note(title: title,
                        content: content,
                        importance: importance)
    }
    
    override func tearDown() {
        noteMock = nil
        super.tearDown()
    }
    
    func testNote_isStruct() {
        guard let note = noteMock,
            let displayStyle = Mirror(reflecting: note).displayStyle else {
            XCTFail()
            return
        }
        XCTAssertEqual(displayStyle, .struct)
    }
    
    func testNote_whenInitialized_isSetUid() {
        let note = Note(title: title,
                        content: content,
                        importance: importance,
                        uid: uid)
        
        XCTAssertEqual(uid, note.uid)
    }
    
    func testNote_whenInitialized_isSetDefaultUid() {
        let note = Note(title: title,
                        content: content,
                        importance: importance)
        
        XCTAssertNotEqual(noteMock.uid, note.uid)
    }
    
    func testNote_whenInitialized_setTitle() {
        XCTAssertEqual(noteMock.title, title)
    }
    
    func testNote_whenInitialized_setContent() {
        XCTAssertEqual(noteMock.content, content)
    }
    
    func testNote_whenInitialized_setImportance() {
        XCTAssertEqual(noteMock.importance, importance.rawValue)
    }
    
    
    func testNote_whenInitialized_defaultColor() {
        XCTAssertEqual(noteMock.color, .white)
    }
    
    func testNote_whenInitialized_customColor() {
        let color = UIColor.red
        let note = Note(title: title,
                        content: content,
                        importance: importance,
                        color: color)
        
        XCTAssertEqual(note.color, color)
    }
    
    func testNote_whenInitialized_defaultDate() {
        XCTAssertNil(noteMock.selfDestructionDate)
    }
    
    func testNote_whenInitialized_customDate() {
        let date = Date()
        let note = Note(title: title,
                        content: content,
                        importance: importance,
                        selfDestructionDate: date)
        
        XCTAssertEqual(date, note.selfDestructionDate)
    }
    
}
