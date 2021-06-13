//
//  DetectorTests.swift
//  
//
//  Created by Jochen Kiemes on 12.06.21.
//

@testable import Euclid
import XCTest

class DetectorTests: XCTestCase {
    // MARK: Subtraction

    func testDetectSingleMesh() {
        let a = Mesh.cube()
        let detected = a.detectSubMeshes()
        XCTAssert(detected.count == 1)
    }
    func testCombinedMeshWithDistance() {
        let a = Mesh.cube(size:1).translated(by: Vector(2,0,0))
        let b = Mesh.cube(size:1)
        let c = a.union(b)
        let detected = c.detectSubMeshes()
        XCTAssert(detected.count == 2)
    }
    func testCombinedMeshAttachedAtFace() {
        let a = Mesh.cube(size:1).translated(by: Vector(1,0,0))
        let b = Mesh.cube(size:1)
        let c = a.union(b)
        let detected = c.detectSubMeshes()
        XCTAssert(detected.count == 1)
    }
    func testCombinedMeshAttachedAtEdge() {
        let a = Mesh.cube(size:1).translated(by: Vector(1,1,0))
        let b = Mesh.cube(size:1)
        let c = a.union(b)
        let detected = c.detectSubMeshes()
        XCTAssert(detected.count == 2)
    }
    func testCombinedMeshAttachedAtPoint() {
        let a = Mesh.cube(size:1).translated(by: Vector(1,1,1))
        let b = Mesh.cube(size:1)
        let c = a.union(b)
        let detected = c.detectSubMeshes()
        XCTAssert(detected.count == 2)
    }
    func testDetectFourSubmeshes_4() {
        let a = Mesh.cube(size:50)
        let b = Mesh.cylinder(radius:30, height:60)
        let c = a.subtract(b)
        let detected = c.detectSubMeshes()
        XCTAssert(detected.count == 4)
    }
}
