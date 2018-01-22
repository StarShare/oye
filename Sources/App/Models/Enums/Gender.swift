//
//  Gender.swift
//  oyePackageDescription
//
//  Created by BUBUKO on 2018/1/21.
//

public enum Gender: Equatable {
  case male
  case female
  case custom(String)
  
  public init(id string: String) {
    switch string.lowercased() {
    case "男":
      self = .male
    case "女":
      self = .female
    default:
      self = .custom(string)
    }
  }
}

extension Gender: CustomStringConvertible {
  
  public var description: String {
    switch self {
    case .male: return "男"
    case .female: return "女"
    case .custom(let string): return string
    }
  }
}

public func == (lhs: Gender, rhs: Gender) -> Bool {
  return lhs.description == rhs.description
}
