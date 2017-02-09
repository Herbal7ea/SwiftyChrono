//
//  DEDeadlineFormatParser.swift
//  SwiftyChrono
//
//  Created by Jerry Chen on 2/8/17.
//  Copyright © 2017 Potix. All rights reserved.
//

import Foundation

private let PATTERN = "(\\W|^)" +
    "(Innerhalb|i[n|m])\\s*" +
    "(\(DE_INTEGER_WORDS_PATTERN)|[0-9]+|\(DE_INTEGER1_WORDS_PATTERN)(?:\\s*(?:wenigen?|einigen?|paar))?|halbe(?:n|s)?(?:\\s*\(DE_INTEGER1_WORDS_PATTERN))?)\\s*" +
    "(sekunden?|minuten?|stunden?|tag(?:e|en)?|wochen?|monat(?:e|en)?|jahr(?:e|en)??)\\s*" +
    "(?=\\W|$)"

private let HALF = 0.5
private let HALF_SECOND = millisecondsToNanoSeconds(500) // unit: nanosecond

public class DEDeadlineFormatParser: Parser {
    override var pattern: String { return PATTERN }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)
        result.tags[.deDeadlineFormatParser] = true
        
        let number: Double
        let numberText = match.string(from: text, atRangeIndex: 3).lowercased()
        if let number0 = DE_INTEGER_WORDS[numberText] {
            number = Double(number0)
        } else if DE_INTEGER1_WORDS[numberText] != nil {
            number = 1
        } else if NSRegularExpression.isMatch(forPattern: "wenige|einige|paar", in: numberText) {
            number = 3
        } else if NSRegularExpression.isMatch(forPattern: "halbe", in: numberText) {
            number = HALF
        } else {
            number = Double(numberText)!
        }
        
        var date = ref
        let matchText4 = match.string(from: text, atRangeIndex: 4)
        func ymdResult() -> ParsedResult {
            result.start.assign(.year, value: date.year)
            result.start.assign(.month, value: date.month)
            result.start.assign(.day, value: date.day)
            return result
        }
        if NSRegularExpression.isMatch(forPattern: "tag", in: matchText4) {
            date = number != HALF ? date.added(Int(number), .day) : date.added(12, .hour)
            return ymdResult()
        } else if NSRegularExpression.isMatch(forPattern: "woche", in: matchText4) {
            date = number != HALF ? date.added(Int(number * 7), .day) : date.added(3, .day).added(12, .hour)
            return ymdResult()
        } else if NSRegularExpression.isMatch(forPattern: "monat", in: matchText4) {
            date = number != HALF ? date.added(Int(number), .month) : date.added((date.numberOf(.day, inA: .month) ?? 30)/2, .day)
            return ymdResult()
        } else if NSRegularExpression.isMatch(forPattern: "jahr", in: matchText4) {
            date = number != HALF ? date.added(Int(number), .year) : date.added(6, .month)
            return ymdResult()
        }
        
        
        
        if NSRegularExpression.isMatch(forPattern: "stunde", in: matchText4) {
            date = number != HALF ? date.added(Int(number), .hour) : date.added(30, .minute)
        } else if NSRegularExpression.isMatch(forPattern: "minute", in: matchText4) {
            date = number != HALF ? date.added(Int(number), .minute) : date.added(30, .second)
        } else if NSRegularExpression.isMatch(forPattern: "sekunde", in: matchText4) {
            date = number != HALF ? date.added(Int(number), .second) : date.added(HALF_SECOND, .nanosecond)
        }
        
        
        result.start.imply(.year, to: date.year)
        result.start.imply(.month, to: date.month)
        result.start.imply(.day, to: date.day)
        result.start.assign(.hour, value: date.hour)
        result.start.assign(.minute, value: date.minute)
        result.start.assign(.second, value: date.second)
        
        return result
    }
}

