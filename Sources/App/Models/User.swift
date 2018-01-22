import Vapor
import FluentProvider
import HTTP

final class User: Model {
  let storage = Storage()
  
  var name: String
  
  struct Keys {
    static let id = "id"
    static let name = "name"
  }
  
  init(name: String) {
    self.name = name
  }
  
  init(row: Row) throws {
    name = try row.get(User.Keys.name)
  }
  
  func makeRow() throws -> Row {
    var row = Row()
    try row.set(User.Keys.name, name)
    return row
  }
}

// MARK: Fluent Preparation

extension User: Preparation {
  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string(User.Keys.name)
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

// MARK: JSON

extension User: JSONConvertible {
  convenience init(json: JSON) throws {
    self.init(
      name: try json.get(User.Keys.name)
    )
  }
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(User.Keys.id, id)
    try json.set(User.Keys.name, name)
    return json
  }
}

// MARK: HTTP

extension User: ResponseRepresentable { }

// MARK: Update

extension User: Updateable {
  public static var updateableKeys: [UpdateableKey<User>] {
    return [
      UpdateableKey(User.Keys.name, String.self) { user, name in
        user.name = name
      }
    ]
  }
}

