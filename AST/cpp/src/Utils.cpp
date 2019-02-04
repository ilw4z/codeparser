
#include "Utils.h"

#include "Symbol.h"

#include <cctype>
#include <sstream>
#include <iomanip>
#include <iostream>
#include <cassert>
#include <string>
#include <memory>
#include <vector>

int parseInteger(std::string s, int base) {
    return std::stoi(s, nullptr, base);
}

std::string stringEscape(std::string s) {
    std::ostringstream escaped;
    escaped << "\"";
    for (size_t i = 0; i < s.size(); i++) {
        auto c = s[i];
        switch (c) {
            case '\\':
                escaped << "\\\\";
                break;
            case '"':
                escaped << "\\\"";
                break;
            default:
                escaped << c;
                break;
        }
    }
    escaped << "\"";
    
    return escaped.str();
}


std::string ASTSourceString(SourceSpan span) {
    std::ostringstream ss;
    ss << SYMBOL_SOURCE.name();
    ss << "->{";
    ss << span.start.string();
    ss << ", ";
    ss << span.end.string();
    ss << "}";
    return ss.str();
}
