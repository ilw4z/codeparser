
#pragma once

#include "Utils.h"
#include "CharacterDecoder.h"
#include "Token.h"
#include "SyntaxIssue.h"

#include <vector>

//
// Tokenizer takes a stream of WL characters and tokenizes them
//
class Tokenizer {
    
    bool _stringifyNextToken;
    Token cur;
    
    std::vector<std::pair<WLCharacter, SourceLocation>> characterQueue;
    bool currentCached;
    WLCharacter _currentWLCharacter;
    SourceLocation _currentSourceLocation;

    std::ostringstream String;

    std::vector<SyntaxIssue> Issues;
    
    bool expectDigits();
    void handleDigits();
    bool handleDigitsOrAlpha(int base);
    void handleDigitsOrAlphaOrDollar();
    
    Token handleComment();
    Token handleString();
    
    void handleSymbolSegment();
    Token handleSymbol();
    
    Token handleNumber();
    bool handleFractionalPart(int base);
    
    Token handleOperator();
    
    Token handleLinearSyntax();
    
    Token handleDot();

    WLCharacter nextWLCharacter(NextCharacterPolicy policy = POLICY_PRESERVE_WHITESPACE_AFTER_LINE_CONTINUATION);

    WLCharacter currentWLCharacter();
    void setCurrentWLCharacter(WLCharacter, SourceLocation);
    
public:
    Tokenizer();
    
    void init(bool skipFirstLine);
    
    Token nextToken();
    
    Token currentToken();
    
    std::string getString();

    std::vector<SyntaxIssue> getIssues();
};

extern Tokenizer *TheTokenizer;
