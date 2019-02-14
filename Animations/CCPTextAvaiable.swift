//
//  TextPathAnimation.swift
//  CCPTextAnimation
//
//  Created by 储诚鹏 on 2019/1/30.
//  Copyright © 2019 储诚鹏. All rights reserved.
//

import UIKit

extension String: CCPTextAvaiable {
    public var text: String { return self }
}

extension Date: CCPTextAvaiable {
    public var text: String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return "时间是: " + format.string(from: self)
    }
}

extension Data: CCPTextAvaiable {
    public var text: String {
        return String.init(data: self, encoding: .utf8) ?? "不能把当前data转换成字符串"
    }
}

public protocol CCPTextAvaiable {
    var text: String { get }
    func bezierPath() -> UIBezierPath
}

extension CCPTextAvaiable {
    
    public func bezierPath() -> UIBezierPath {
        return self.bezierPath(from: self.text)
    }
    
    private func bezierPath(from str: String) -> UIBezierPath {
        let fontName = __CFStringMakeConstantString("PingFangSC-Regular")!
        let cFont = CTFontCreateWithName(fontName, 25, nil)
        let attributeStr = NSAttributedString(string: str, attributes: [.font : cFont])
        let line = CTLineCreateWithAttributedString(attributeStr as CFAttributedString)
        let bPath = UIBezierPath()
        bPath.move(to: .zero)
        bPath.append(UIBezierPath(cgPath: paths(CTLineGetGlyphRuns(line), fontName)))
        return bPath
    }
    
    private func path(_ ctRun: CTRun, _ ctRunFont: CTFont, _ mPath: CGMutablePath) {
        
        for ctIdx in 0 ..< CTRunGetGlyphCount(ctRun) {
            let range = CFRange(location: ctIdx, length: 1)
            let glyph = UnsafeMutablePointer<CGGlyph>.allocate(capacity: 1)
            glyph.initialize(to: 0)
            let pos = UnsafeMutablePointer<CGPoint>.allocate(capacity: 1)
            pos.initialize(to: .zero)
            CTRunGetGlyphs(ctRun, range, glyph)
            CTRunGetPositions(ctRun, range, pos)
            let posX = pos.pointee.x
            let rate = Int(posX / UIScreen.main.bounds.width)
            print(glyph)
            guard let path = CTFontCreatePathForGlyph(ctRunFont, glyph.pointee, nil) else { continue }
            let x = rate > 0 ? 0 : posX
            let y = pos.pointee.y - CGFloat(rate) * 88
            mPath.addPath(path, transform: CGAffineTransform(translationX: x, y: y))
            glyph.deallocate()
            pos.deallocate()
        }
    }
    
    private func paths(_ runs: CFArray, _ fontName: CFString) -> CGPath {
        let mPath = CGMutablePath()
        let ctFontName = unsafeBitCast(__CFStringMakeConstantString("NSFont"), to: UnsafeRawPointer.self)
        for idx in 0 ..< CFArrayGetCount(runs) {
            let ctRun = unsafeBitCast(CFArrayGetValueAtIndex(runs, idx), to: CTRun.self)
            let runFont = CFDictionaryGetValue(CTRunGetAttributes(ctRun), ctFontName)
            let ctRunFont = unsafeBitCast(runFont, to: CTFont.self)
            path(ctRun, ctRunFont, mPath)
        }
        return mPath
    }
}


