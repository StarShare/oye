import Vapor
import HTTP

final class SignController: ResourceRepresentable {
  
  /// When users call 'GET' on '/Users'
  /// it should return an index of all available Users
  func index(_ req: Request) throws -> ResponseRepresentable {
    return try User.all().makeJSON()
  }
  
  /// When consumers call 'User' on '/Users' with valid JSON
  /// construct and save the User
  func store(_ req: Request) throws -> ResponseRepresentable {
    let user = try req.user()
    try user.save()
    return user
  }
  
  /// When the consumer calls 'GET' on a specific resource, ie:
  /// '/Users/13rd88' we should show that specific User
  func show(_ req: Request, user: User) throws -> ResponseRepresentable {
    return user
  }
  
  /// When the consumer calls 'DELETE' on a specific resource, ie:
  /// 'Users/l2jd9' we should remove that resource from the database
  func delete(_ req: Request, user: User) throws -> ResponseRepresentable {
    try user.delete()
    return Response(status: .ok)
  }
  
  /// When the consumer calls 'DELETE' on the entire table, ie:
  /// '/Users' we should remove the entire table
  func clear(_ req: Request) throws -> ResponseRepresentable {
    try User.makeQuery().delete()
    return Response(status: .ok)
  }
  
  /// When the user calls 'PATCH' on a specific resource, we should
  /// update that resource to the new values.
  func update(_ req: Request, user: User) throws -> ResponseRepresentable {
    try user.update(for: req)
    try user.save()
    return user
  }
  
  /// When a user calls 'PUT' on a specific resource, we should replace any
  /// values that do not exist in the request with null.
  /// This is equivalent to creating a new User with the same ID.
  func replace(_ req: Request, user: User) throws -> ResponseRepresentable {
    let new = try req.user()
    
    user.name = new.name
    try user.save()
    
    return user
  }
  
  /// When making a controller, it is pretty flexible in that it
  /// only expects closures, this is useful for advanced scenarios, but
  /// most of the time, it should look almost identical to this
  /// implementation
  func makeResource() -> Resource<User> {
    return Resource(
      index: index,
      store: store,
      show: show,
      update: update,
      replace: replace,
      destroy: delete,
      clear: clear
    )
  }
}

extension Request {
  /// Create a User from the JSON body
  /// return BadRequest error if invalid
  /// or no JSON
  func user() throws -> User {
    print(self)
    if headers["Content-Type"] == "multipart/json" {
      guard let json = json else { throw Abort.badRequest }
      return try User(json: json)
    }
    
    guard let name = data["name"]?.string else { throw Abort.badRequest }
    return User(name: name)
  }
}

/// Since UserController doesn't require anything to
/// be initialized we can conform it to EmptyInitializable.
///
/// This will allow it to be passed by type.
extension SignController: EmptyInitializable { }

