//
//  SugarAnchor.swift
//  SugarAnchor
//
//  Created by Ashik uddin Ahmad on 5/9/17.
//  Copyright © 2017 AshKit. All rights reserved.
//

import UIKit


//==============================================================
//MARK: - Operator defination
//==============================================================

precedencegroup ConstraintPrecedence { lowerThan: AdditionPrecedence }

/// Make inactive equal constraint
infix operator =~=: ConstraintPrecedence
/// Make inactive lessThanOrEqual constraint
infix operator <~=: ConstraintPrecedence
/// Make inactive greaterThanOrEqual constraint
infix operator >~=: ConstraintPrecedence

/// Make active equal constraint
infix operator =*=: ConstraintPrecedence
/// Make active lessThanOrEqual constraint
infix operator <*=: ConstraintPrecedence
/// Make active greaterThanOrEqual constraint
infix operator >*=: ConstraintPrecedence

//==============================================================
//MARK: - Conformation
//==============================================================

public protocol Constraintable {
    associatedtype AnchorType: AnyObject
    
    /* These methods return an inactive constraint of the form thisAnchor = otherAnchor + constant.
     */
    func constraint(equalTo anchor: NSLayoutAnchor<AnchorType>, constant c: CGFloat) -> NSLayoutConstraint
    
    func constraint(greaterThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>, constant c: CGFloat) -> NSLayoutConstraint
    
    func constraint(lessThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>, constant c: CGFloat) -> NSLayoutConstraint
}

extension NSLayoutXAxisAnchor: Constraintable {}
extension NSLayoutYAxisAnchor: Constraintable {}
extension NSLayoutDimension: Constraintable {}

public struct LayoutDimensionInfo {
    let anchor: NSLayoutDimension
    let multiplier: CGFloat
    let constant: CGFloat
}

extension Constraintable {
    
    fileprivate func constraint(_ other: Self, c: CGFloat = 0, active: Bool = true)->NSLayoutConstraint {
        let constraint = self.constraint(equalTo: other as! NSLayoutAnchor<AnchorType>, constant: c)
        constraint.isActive = active
        return constraint
    }
    
    fileprivate func constraintGreater(_ other: Self, c: CGFloat = 0, active: Bool = true)->NSLayoutConstraint {
        let constraint = self.constraint(greaterThanOrEqualTo: other as! NSLayoutAnchor<AnchorType>, constant: c)
        constraint.isActive = active
        return constraint
    }
    
    fileprivate func constraintLess(_ other: Self, c: CGFloat = 0, active: Bool = true)->NSLayoutConstraint {
        let constraint = self.constraint(lessThanOrEqualTo: other as! NSLayoutAnchor<AnchorType>, constant: c)
        constraint.isActive = active
        return constraint
    }
}

//==============================================================
//MARK: - Common Operator implementation
//==============================================================

public extension Constraintable {
    
    public static func + (lhs: Self, rhs: CGFloat)->(Self, CGFloat) {
        return (lhs, rhs)
    }
    
    public static func - (lhs: Self, rhs: CGFloat)->(Self, CGFloat) {
        return (lhs, -rhs)
    }
    
    //--------------------------------------------------------------
    //MARK: - "Equal" Operations (Inactive)
    //-------------------------------------------------------------
    
    @discardableResult
    public static func =~=(lhs: Self, rhs: Self)->NSLayoutConstraint {
        return lhs.constraint(rhs, active: false)
    }
    
    @discardableResult
    public static func =~=(lhs: Self, rhs: (Self, CGFloat))->NSLayoutConstraint {
        return lhs.constraint(rhs.0, c: rhs.1, active: false)
    }
    
    //--------------------------------------------------------------
    //MARK: - "Equal" Operations (Active)
    //-------------------------------------------------------------
    
    @discardableResult
    public static func =*=(lhs: Self, rhs: Self)->NSLayoutConstraint {
        return lhs.constraint(rhs)
    }
    
    @discardableResult
    public static func =*=(lhs: Self, rhs: (Self, CGFloat))->NSLayoutConstraint {
        return lhs.constraint(rhs.0, c: rhs.1)
    }
    
    //--------------------------------------------------------------
    //MARK: - "LessThanOrEqual" Operations (Inactive)
    //-------------------------------------------------------------
    
    @discardableResult
    public static func <~=(lhs: Self, rhs: Self)->NSLayoutConstraint {
        return lhs.constraintLess(rhs, active: false)
    }
    
    @discardableResult
    public static func <~=(lhs: Self, rhs: (Self, CGFloat))->NSLayoutConstraint {
        return lhs.constraintLess(rhs.0, c: rhs.1, active: false)
    }
    
    //--------------------------------------------------------------
    //MARK: - "LessThanOrEqual" Operations (Active)
    //-------------------------------------------------------------
    
    @discardableResult
    public static func <*=(lhs: Self, rhs: Self)->NSLayoutConstraint {
        return lhs.constraintLess(rhs)
    }
    
    @discardableResult
    public static func <*=(lhs: Self, rhs: (Self, CGFloat))->NSLayoutConstraint {
        return lhs.constraintLess(rhs.0, c: rhs.1)
    }
    
    //--------------------------------------------------------------
    //MARK: - "GreaterThanOrEqual" Operations (Inactive)
    //-------------------------------------------------------------
    
    @discardableResult
    public static func >~=(lhs: Self, rhs: Self)->NSLayoutConstraint {
        return lhs.constraintGreater(rhs, active: false)
    }
    
    @discardableResult
    public static func >~=(lhs: Self, rhs: (Self, CGFloat))->NSLayoutConstraint {
        return lhs.constraintGreater(rhs.0, c: rhs.1, active: false)
    }
    
    //--------------------------------------------------------------
    //MARK: - "GreaterThanOrEqual" Operations (Active)
    //-------------------------------------------------------------
    
    @discardableResult
    public static func >*=(lhs: Self, rhs: Self)->NSLayoutConstraint {
        return lhs.constraintGreater(rhs)
    }
    
    @discardableResult
    public static func >*=(lhs: Self, rhs: (Self, CGFloat))->NSLayoutConstraint {
        return lhs.constraintGreater(rhs.0, c: rhs.1)
    }
}

//==============================================================
//MARK: - NSLayoutDimension Only Operations
//==============================================================

public func + (lhs: LayoutDimensionInfo, rhs: CGFloat)->LayoutDimensionInfo {
    return LayoutDimensionInfo(anchor: lhs.anchor, multiplier: lhs.multiplier, constant: lhs.constant + rhs)
}

public func - (lhs: LayoutDimensionInfo, rhs: CGFloat)->LayoutDimensionInfo {
    return LayoutDimensionInfo(anchor: lhs.anchor, multiplier: lhs.multiplier, constant: lhs.constant - rhs)
}

public extension NSLayoutDimension {
    
    //--------------------------------------------------------------
    //MARK: - Support multiplier & constant
    //-------------------------------------------------------------
    
    public static func * (lhs: NSLayoutDimension, rhs: CGFloat)->LayoutDimensionInfo {
        return LayoutDimensionInfo(anchor: lhs, multiplier: rhs, constant: 0)
    }
    
    public static func / (lhs: NSLayoutDimension, rhs: CGFloat)->LayoutDimensionInfo {
        return LayoutDimensionInfo(anchor: lhs, multiplier: 1/rhs, constant: 0)
    }
    
    public static func * (lhs: CGFloat, rhs: NSLayoutDimension)->LayoutDimensionInfo {
        return LayoutDimensionInfo(anchor: rhs, multiplier: lhs, constant: 0)
    }
    
    public static func / (lhs: CGFloat, rhs: NSLayoutDimension)->LayoutDimensionInfo {
        return LayoutDimensionInfo(anchor: rhs, multiplier: 1/lhs, constant: 0)
    }
    
    //--------------------------------------------------------------
    //MARK: - Equality Operations (Inactive)
    //-------------------------------------------------------------
    
    @discardableResult
    public static func =~=(lhs: NSLayoutDimension, rhs: CGFloat)->NSLayoutConstraint {
        return lhs.constraint(equalToConstant: rhs)
    }
    
    @discardableResult
    public static func =~= (lhs: NSLayoutDimension, rhs: LayoutDimensionInfo)->NSLayoutConstraint {
        return lhs.constraint(equalTo: rhs.anchor, multiplier: rhs.multiplier, constant: rhs.constant)
    }
    
    //--------------------------------------------------------------
    //MARK: - "Equal" Operations (Active)
    //-------------------------------------------------------------
    
    @discardableResult
    public static func =*=(lhs: NSLayoutDimension, rhs: CGFloat)->NSLayoutConstraint {
        let constraint = lhs.constraint(equalToConstant: rhs)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public static func =*= (lhs: NSLayoutDimension, rhs: LayoutDimensionInfo)->NSLayoutConstraint {
        let constraint = lhs.constraint(equalTo: rhs.anchor, multiplier: rhs.multiplier, constant: rhs.constant)
        constraint.isActive = true
        return constraint
    }
    
    //--------------------------------------------------------------
    //MARK: - "LessThanOrEqual" Operations (Inactive)
    //-------------------------------------------------------------
    
    @discardableResult
    public static func <~=(lhs: NSLayoutDimension, rhs: CGFloat)->NSLayoutConstraint {
        return lhs.constraint(lessThanOrEqualToConstant: rhs)
    }
    
    @discardableResult
    public static func <~= (lhs: NSLayoutDimension, rhs: LayoutDimensionInfo)->NSLayoutConstraint {
        return lhs.constraint(lessThanOrEqualTo: rhs.anchor, multiplier: rhs.multiplier, constant: rhs.constant)
    }
    
    //--------------------------------------------------------------
    //MARK: - "LessThanOrEqual" Operations (Active)
    //-------------------------------------------------------------
    
    @discardableResult
    public static func <*=(lhs: NSLayoutDimension, rhs: CGFloat)->NSLayoutConstraint {
        let constraint = lhs.constraint(lessThanOrEqualToConstant: rhs)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public static func <*= (lhs: NSLayoutDimension, rhs: LayoutDimensionInfo)->NSLayoutConstraint {
        let constraint = lhs.constraint(lessThanOrEqualTo: rhs.anchor, multiplier: rhs.multiplier, constant: rhs.constant)
        constraint.isActive = true
        return constraint
    }
    
    //--------------------------------------------------------------
    //MARK: - "GreaterThanOrEqual" Operations (Inactive)
    //-------------------------------------------------------------
    
    @discardableResult
    public static func >~=(lhs: NSLayoutDimension, rhs: CGFloat)->NSLayoutConstraint {
        return lhs.constraint(greaterThanOrEqualToConstant: rhs)
    }
    
    @discardableResult
    public static func >~= (lhs: NSLayoutDimension, rhs: LayoutDimensionInfo)->NSLayoutConstraint {
        return lhs.constraint(greaterThanOrEqualTo: rhs.anchor, multiplier: rhs.multiplier, constant: rhs.constant)
    }
    
    //--------------------------------------------------------------
    //MARK: - "GreaterThanOrEqual" Operations (Active)
    //-------------------------------------------------------------
    
    @discardableResult
    public static func >*=(lhs: NSLayoutDimension, rhs: CGFloat)->NSLayoutConstraint {
        let constraint = lhs.constraint(greaterThanOrEqualToConstant: rhs)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public static func >*= (lhs: NSLayoutDimension, rhs: LayoutDimensionInfo)->NSLayoutConstraint {
        let constraint = lhs.constraint(greaterThanOrEqualTo: rhs.anchor, multiplier: rhs.multiplier, constant: rhs.constant)
        constraint.isActive = true
        return constraint
    }
}
