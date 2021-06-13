//
//  Detector.swift
//  Euclid
//
//  Created by J.Kiemes on 06/12/2021.
//  Copyright © 2021 J.Kiemes. All rights reserved.
//
//  Distributed under the permissive MIT license
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/Euclid
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
private struct Edge: Hashable {
    var p1: Vector
    var p2: Vector
}

public extension Mesh {
    func detectSubMeshes() -> [Mesh] {
        var polygonToEdges: [Polygon: [Edge]] = [:]
        var edgeToPolygons: [Edge: [Polygon]] = [:] // must be even number of polygons
        
        for polygon in polygons {
            var edges: [Edge] = []
            for i in 0 ..< polygon.vertices.count {
                var j = i + 1
                if j == polygon.vertices.count {
                    j = 0
                }
                var p_i = polygon.vertices[i].position
                var p_j = polygon.vertices[j].position
                var swap = false
                if p_i.x > p_j.x {
                    swap = true
                }
                else if p_i.x == p_j.x {
                    if p_i.y > p_j.y {
                        swap = true
                    }
                    else if p_i.y == p_j.y {
                        if p_i.z > p_j.z {
                            swap = true
                        }
                        if p_i.z == p_j.z {
                            print("NOW WHAT ?")
                        }
                    }
                }
                if swap {
                    let temp = p_i
                    p_i = p_j
                    p_j = temp
                }
                let e = Edge(p1: p_i, p2: p_j)
                edges.append(e)
                    
                var polys = edgeToPolygons.removeValue(forKey: e) ?? []
                polys.append(polygon)
                edgeToPolygons[e] = polys
            }
            polygonToEdges[polygon] = edges
        }
        
        var filteredEdgesToPolygon = edgeToPolygons.filter({
           (e: Edge, p: [Polygon]) in p.count == 2
        })
        
        var submeshes: [Mesh] = []
        while let pair = filteredEdgesToPolygon.first {
            var submesh: [Polygon] = []
            var edgesOfSubmesh: Set<Edge> = []
            var edgesToGo: Set<Edge> = []
            
            // Start with one random edge
            edgesToGo.insert(pair.0)
            while let edge = edgesToGo.first {
                edgesToGo.remove(edge)
                edgesOfSubmesh.insert(edge)
                if let polys = filteredEdgesToPolygon.removeValue(forKey: edge) {
                    for poly in polys {
                        for e in polygonToEdges[poly]! {
                            if !edgesOfSubmesh.contains(e) {
                                edgesToGo.insert(e)
                            }
                        }
                        submesh.append(poly)
                    }
                }
            }
            submeshes.append(Mesh(submesh))
        }
        return submeshes
    }
}
