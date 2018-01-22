import Vapor

extension Droplet {
  func setupRoutes() throws {
    
    get("hello") { req in
      var json = JSON()
      try json.set("hello", "world")
      return json
    }
    
    get("/") { req in
      var json = JSON()
      try json.set("name","oye!")
      return json
    }
    
    get("description") { req in return req.description }
    
    try resource("sign", SignController.self)
  }
}

