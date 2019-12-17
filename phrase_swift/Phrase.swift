//
//  NSMutableAttributedString+Extensions.swift
//  Phrase_Swift
//
//  Created by Jan Meier on 09.12.19.
//

import UIKit


public final class Phrase {
    
    // the unmodified original pattern
    private var pattern: String
    
    // all keys parsed from the original pattern, without braces
    private var keys: Set<String> = []
    private var keysToValue = [String: String]()
    
    // cached result after replacing all keys with corresponding values
    private var formatted: String?
    
    // the constructor parses the original pattern into this doubly-linked list of tokens
    private var head: Token?
    
    // when parsing, this is the current char
    private var curChar: Character
    private var curCharIndex: Int = 0
    
    // indicates parsing is complete
    
    // TODO: make it int 1
    public static let EOF: Character = Character(UnicodeScalar(0))
    
    public func put(key: String, value: String) -> Phrase {
        guard keys.contains(key) else  {
            
            exit(34)
        }
        
        keysToValue[key] = value
        
        // Invalidate the cached formatted text
        formatted = nil
        return self
        
    }
    
    public func  putOptional(key: String, value: String) -> Phrase {
        if keys.contains(key) {
            put(key: key, value: value)
        }
        return self
    }
    
    public func format() -> String {
        if formatted == nil {
            // TODO: perf?
            let keysOfTranslations = Set(keysToValue.map { $0.key })
            print("items: " + keysOfTranslations.joined(separator: ","))
            if !keysOfTranslations.isSuperset(of: keys) {
                let missingKeys = keys.subtracting(keysOfTranslations)
                print("missing keys " + missingKeys.joined(separator: ","))
                exit(60)
            }
            
            // Copy the original pattern to preserve all spans, such as bold, italic, etc.
            let sb = NSMutableAttributedString(string: pattern)
            while let t = head?.next {
                t.expand(target: sb, data: keysToValue)
                head = head!.next
            }
            formatted = sb.string
            
        }
        return formatted!
        
    }
    
    public init(pattern: String) {
        curChar = (pattern.count > 0) ? pattern.charAt(index: 0) : Phrase.EOF;
        
        self.pattern = pattern
        
        // A hand-coded lexer based on the idioms in "Building Recognizers By Hand".
        // http://www.antlr2.org/book/byhand.pdf.
        
        var prev: Token? = nil
        while let next = token(prev: prev) {
            // creates a doubly-linked list of tokens starting with head
            if head == nil { head = next }
            prev = next
        }
    }
    
    // returns the next token from the input, or nil when finished parsing
    private func token(prev: Token?) -> Token? {
        if curChar == Phrase.EOF {
            return nil
        }
        
        if self.curChar == "{" {
            let nextChar = lookahead()
            if nextChar == "{" {
                return leftCurlyBracket(prev: prev)
            } else if nextChar >= "a" && nextChar <= "z" {
                return key(prev: prev)
            } else {
                exit(108)
                //            throw IllegalArgumentException(
                //                "Unexpected first character '" + nextChar + "; must be lower case a-z"
                //            );
            }
        }
        return text(prev: prev)
    }
    
    
    // parses a key "{some_key}".
    
    private func key(prev: Token?) -> KeyToken {
        // Store keys as normal Strings; we don't want keys to contain spans.
        var sb = ""
        
        /// consume the opening "{"
        consume()
        while ((curChar >= "a" && curChar <= "z") || curChar == "_") {
            sb.append(curChar)
            consume()
        }
        
        // consume the closing '}'
        if curChar != "}" {
            // TODO: throw properly
            exit(1);
        }
        consume()
        
        // disabllow empty keys: {}
        if sb.count == 0 {
            // TODO: throw properly
            exit(140)
        }
        
        let key = sb
        
        keys.insert(key)
        return KeyToken(prev: prev, key: key)
        
    }
    
    
    /** Consumes and returns a token for a sequence of text. */
    private func  text(prev : Token?) -> TextToken {
        let startIndex = curCharIndex;
        
        while (curChar != "{" && curChar != Phrase.EOF) {
            consume();
        }
        return TextToken(prev: prev, textLength: curCharIndex - startIndex);
    }
    
    /** Consumes and returns a token representing two consecutive curly brackets. */
    private func leftCurlyBracket(prev: Token?) -> LeftCurlyBracketToken {
        consume()
        consume()
        return LeftCurlyBracketToken(prev: prev)
    }
    
    /** Returns the next character in the input pattern without advancing. */
    private func lookahead() -> Character {
        var result : Character = Phrase.EOF
        if curCharIndex < pattern.count-1 {
            result = pattern.charAt(index: curCharIndex + 1)
        }
        return result
    }
    
    /**
     * Advances the current character position without any error checking. Consuming beyond the
     * end of the string can only happen if this parser contains a bug.
     */
    private func consume() {
        curCharIndex+=1
        if curCharIndex == pattern.count {
            curChar = Phrase.EOF
        } else {
            curChar = pattern.charAt(index: curCharIndex)
        }
    }
    
    
    
    // make abstract
    private class Token {
        private final var prev: Token?
        var next : Token?
        
        init(prev: Token?) {
            self.prev = prev;
            if prev != nil {
                prev!.next = self
            }
        }
        
        /** Replace text in {@code target} with this token's associated value. */
        func expand(target: NSMutableAttributedString, data : [String: String]) {
            exit(207)
        }
        
        /** Returns the number of characters after expansion. */
        func  getFormattedLength() -> Int {
            exit(212)
        }
        
        /** Returns the character index after expansion. */
        func getFormattedStart() -> Int {
            if prev == nil {
                // The first token.
                return 0;
            } else {
                // Recursively ask the predecessor node for the starting index.
                guard prev != nil else {
                    exit(223)
                }
                return prev!.getFormattedStart() + prev!.getFormattedLength();
            }
        }
    }
    
    /** Ordinary text between token(s. */
    private class TextToken : Token {
        private var textLength : Int
        
        init(prev: Token?,  textLength: Int) {
            self.textLength = textLength
            super.init(prev: prev)
        }
        
        override func expand( target : NSMutableAttributedString, data : [String: String]) {
            // Don't alter spans in the target.
        }
        
        override func getFormattedLength() -> Int {
            return textLength;
        }
    }
    
    /** A sequence of two curly brackets. */
    private class LeftCurlyBracketToken : Token {
        override init(prev: Token?) {
            super.init(prev: prev);
        }
        
        override func expand(target: NSMutableAttributedString ,data:  [String: String] ) {
            let start = getFormattedStart();
            target.replace(start: start, end: start + 2, toReplaceWith: "{");
        }
        
        override func getFormattedLength() -> Int {
            // Replace {{ with {.
            return 1;
        }
    }
    
    
    
    private  class KeyToken : Token {
        /** The key without { and }. */
        private var key : String
        private var value : String?
        
        init( prev: Token?, key: String) {
            self.key = key;
            super.init(prev: prev);
            
        }
        
        override func expand( target: NSMutableAttributedString,  data: [String: String]) {
            value = data[key]
            let replaceFrom = getFormattedStart();
            
            // Add 2 to account for the opening and closing brackets.
            let replaceTo = replaceFrom + key.count + 2
            
            target.replace(start: replaceFrom, end: replaceTo, toReplaceWith: value!);
        }
        
        override func getFormattedLength() -> Int {
            // Note that value is only present after expand. Don't error check because this is all
            // private code.
            return value!.count
        }
    }
}
