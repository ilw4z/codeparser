
// #include "Lexer.h"
#include "Parser.h"
#include "Precedence.h"
#include "ByteDecoder.h"
#include "CharacterDecoder.h"
#include "Tokenizer.h"

#include <string>
#include <sstream>
#include <iostream>
#include <fstream>
#include <cassert>


enum Format {
    FORMAT_INPUTFORM,
    FORMAT_AST,
    FORMAT_TOKENS,
    FORMAT_CHARACTERS
};

void printCharacters();
void printTokens();
std::vector<std::shared_ptr<Node>> parseExpressions(bool interactive);

int main(int argc, char *argv[]) {
    
    Format format = FORMAT_AST;
    bool prompt = true;
    bool skipFirstLine = false;

    //
    // interactive: running interactively on the command-line and prints a single expression (because EOF never arrives)
    // so EOF is faked with a newline
    // This means currently that interactive use is limited to a single line
    //
    // nonInteractive: a finite string is sent on stdin and EOF arrives
    //
    bool interactive = true;
    std::string file;
    
    for (int i = 1; i < argc; i++) {
        auto arg = std::string(argv[i]);
        if (arg == "-format") {
            i++;
            auto formatStr = std::string(argv[i]);
            if (formatStr == "inputform") {
                format = FORMAT_INPUTFORM;
            } else if (formatStr == "ast") {
                format = FORMAT_AST;
            } else if (formatStr == "tokens") {
                format = FORMAT_TOKENS;
            } else if (formatStr == "characters") {
                format = FORMAT_CHARACTERS;
            } else {
                return 1;
            }
            
        } else if (arg == "-file") {
            i++;
            file = std::string(argv[i]);
            prompt = false;
            interactive = false;
        } else if (arg == "-noprompt" || arg == "-noPrompt") {
            prompt = false;
        } else if (arg == "-skipfirstline" || arg == "-skipFirstLine") {
            skipFirstLine = true;
        } else if (arg == "-noninteractive" || arg == "-nonInteractive") {
            interactive = false;
        } else {
            return 1;
        }
    }
    
    if (!file.empty()) {
        
        std::ifstream ifs(file, std::ifstream::in);
        
        if (ifs.fail()) {
            return 1;
        }

        TheSourceManager = new SourceManager();
        TheByteDecoder = new ByteDecoder(ifs, interactive);
        TheCharacterDecoder = new CharacterDecoder();
        
        if (format == FORMAT_CHARACTERS) {

            printCharacters();

        } else if (format == FORMAT_TOKENS) {
            
            TheTokenizer = new Tokenizer();
            TheTokenizer->init(skipFirstLine);
            printTokens();

        } else {
            
            TheTokenizer = new Tokenizer();
            TheTokenizer->init(skipFirstLine);
            TheParser = new Parser();
            TheParser->init();
            
            auto nodes = parseExpressions(interactive);
            
            auto FN = std::make_shared<FileNode>(nodes);
            
            switch (format) {
                case FORMAT_INPUTFORM:
                    std::cout << FN->inputform();
                    break;
                case FORMAT_AST:
                    std::cout << FN->string();
                    FN->string();
                    break;
                case FORMAT_TOKENS:
                    // handled elsewhere
                    ;
                    break;
                case FORMAT_CHARACTERS:
                    // handled elsewhere
                    ;
                    break;
            }
            std::cout << "\n";
        }
        
    } else {
            
        if (prompt) {
            std::cout << ">>> ";
        }
        
        TheSourceManager = new SourceManager();
        TheByteDecoder = new ByteDecoder(std::cin, interactive);
        TheCharacterDecoder = new CharacterDecoder();
        
        if (format == FORMAT_CHARACTERS) {

            printCharacters();

        } else if (format == FORMAT_TOKENS) {
            
            TheTokenizer = new Tokenizer();
            TheTokenizer->init(skipFirstLine);
            printTokens();
            
        } else {
            
            TheTokenizer = new Tokenizer();
            TheTokenizer->init(skipFirstLine);
            TheParser = new Parser();
            TheParser->init();
            
            auto nodes = parseExpressions(interactive);
            
            for (std::shared_ptr<Node> node : nodes) {
                switch (format) {
                    case FORMAT_INPUTFORM:
                        std::cout << node->inputform();
                        std::cout << "\n";
                        break;
                    case FORMAT_AST:
                        std::cout << node->string();
                        std::cout << "\n";
                        break;
                    case FORMAT_TOKENS:
                        // handled elsewhere
                        ;
                        break;
                    case FORMAT_CHARACTERS:
                        // handled elsewhere
                        ;
                        break;
                }
            }
        }
    }
    
	return 0;
}

void printCharacters() {

    TheCharacterDecoder->nextWLCharacter();

    std::cout << "{\n";

    while (true) {
        
        auto c = TheCharacterDecoder->currentWLCharacter();

        auto String = WLCharacterToString(c);

        auto Span = TheSourceManager->getWLCharacterSpan();

        std::cout << SYMBOL_CHARACTER.name();
        std::cout << "[";
        std::cout << c;
        std::cout << ", ";
        std::cout << stringEscape(String);
        std::cout << ", <|";
        std::cout << ASTSourceString(Span);
        std::cout << "|>";
        std::cout << "]";

        std::cout << ",\n";

        if (c == WLCHARACTER_EOF) {
            break;
        }
        
        auto Issues = TheCharacterDecoder->getIssues();
        if (!Issues.empty()) {
            auto I = Issues.begin();
            for (; I < Issues.end(); I++) {
                std::cout << (*I).string();
                std::cout << ", ";
            }
        }
        
        TheCharacterDecoder->nextWLCharacter();
    }

    std::cout << "Nothing\n";
    std::cout << "}\n";
}


void printTokens() {

    TheTokenizer->nextToken();

    std::cout << "{\n";

    while (true) {
        
        auto Tok = TheTokenizer->currentToken();

        auto Str = TheTokenizer->getString();

        auto Span = TheSourceManager->getTokenSpan();

        std::cout << SYMBOL_TOKEN.name();
        std::cout << "[";
        std::cout << TokenToString(Tok);
        std::cout << ", ";
        std::cout << stringEscape(Str);
        std::cout << ", <|";
        std::cout << ASTSourceString(Span);
        std::cout << "|>";
        std::cout << "]";

        std::cout << ",\n";

        if (Tok == TOKEN_EOF) {
            break;
        }
        
        TheTokenizer->nextToken();
    }

    std::cout << "Nothing\n";
    std::cout << "}\n";
}

std::vector<std::shared_ptr<Node>> parseExpressions(bool interactive) {

    std::vector<std::shared_ptr<Node>> nodes;
            
    while (true) {
        
        auto peek = TheParser->currentToken();
        
        while (peek == TOKEN_NEWLINE) {
            peek = TheParser->nextToken();
        }
        
        if (peek != TOKEN_EOF) {
            
            auto Expr = TheParser->parseTopLevel();
            
            assert(TheParser->getString().empty());
            assert(TheParser->getIssues().empty());

            nodes.push_back(Expr);
        }

        //
        // This is running on command-line, so only parse first expression
        //
        if (interactive) {
            break;
        }

        peek = TheParser->currentToken();
        
        if (peek == TOKEN_EOF) {
            break;
        }
        
    } // while (true)

    assert(TheParser->getString().empty());
    assert(TheParser->getIssues().empty());

    return nodes;
}


