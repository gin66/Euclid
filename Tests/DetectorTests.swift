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

    func testSubtractCoincidingBoxesWhenTriangulated() {
        let a = Mesh.cube(size:50)
        let b = Mesh.cylinder(radius:30, height:60)
        let c = a.subtract(b)
        let detected = c.detectSubMeshes()
        XCTAssert(detected.count == 4)
    }
}
