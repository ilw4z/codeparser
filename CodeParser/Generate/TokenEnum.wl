BeginPackage["CodeParser`Generate`TokenEnum`"]

isCloser

isError

isDifferentialD


Begin["`Private`"]

Needs["CodeParser`Generate`GenerateSources`"]




(*
Use the System` context symbols for literals when we can

These are compiled as SYMBOL_FOO
*)
tokenToSymbol[Token`EndOfFile] = "Symbol`EndOfFile"
tokenToSymbol[Token`Symbol] = "Symbol`Symbol"
tokenToSymbol[Token`String] = "Symbol`String"
tokenToSymbol[Token`Integer] = "Symbol`Integer"
tokenToSymbol[Token`Real] = "Symbol`Real"

tokenToSymbol[Token`Whitespace] = "Symbol`Whitespace"

tokenToSymbol[Token`Hash] = "Symbol`Slot"
tokenToSymbol[Token`HashHash] = "Symbol`SlotSequence"

tokenToSymbol[Token`Percent] = "Symbol`Out"

tokenToSymbol[Token`Under] = "Symbol`Blank"
tokenToSymbol[Token`UnderUnder] = "Symbol`BlankSequence"
tokenToSymbol[Token`UnderUnderUnder] = "Symbol`BlankNullSequence"

(*
everything else will be Symbol`Token`Foo

which is compiled as SYMBOL_TOKEN_FOO
*)
tokenToSymbol[s_] := "Symbol`"<>ToString[s]










isPossibleBeginningOfExpression[Token`Symbol] = True
isPossibleBeginningOfExpression[Token`String] = True
isPossibleBeginningOfExpression[Token`Integer] = True
isPossibleBeginningOfExpression[Token`Real] = True

isPossibleBeginningOfExpression[Token`Percent] = True

isPossibleBeginningOfExpression[Token`Hash] = True
isPossibleBeginningOfExpression[Token`HashHash] = True

isPossibleBeginningOfExpression[Token`Under] = True
isPossibleBeginningOfExpression[Token`UnderUnder] = True
isPossibleBeginningOfExpression[Token`UnderUnderUnder] = True
isPossibleBeginningOfExpression[Token`UnderDot] = True

isPossibleBeginningOfExpression[Token`SemiSemi] = True

(*
prefix operators
*)
isPossibleBeginningOfExpression[Token`Bang] = True
isPossibleBeginningOfExpression[Token`Minus] = True
isPossibleBeginningOfExpression[Token`Plus] = True
isPossibleBeginningOfExpression[Token`LessLess] = True
isPossibleBeginningOfExpression[Token`MinusMinus] = True
isPossibleBeginningOfExpression[Token`PlusPlus] = True
isPossibleBeginningOfExpression[Token`BangBang] = True

(*
openers
*)
isPossibleBeginningOfExpression[Token`OpenParen] = True
isPossibleBeginningOfExpression[Token`OpenSquare] = True
isPossibleBeginningOfExpression[Token`OpenCurly] = True
isPossibleBeginningOfExpression[Token`LessBar] = True
isPossibleBeginningOfExpression[Token`LongName`LeftCeiling] = True
isPossibleBeginningOfExpression[Token`LongName`LeftFloor] = True
isPossibleBeginningOfExpression[Token`LongName`LeftAngleBracket] = True
isPossibleBeginningOfExpression[Token`LongName`LeftDoubleBracket] = True
isPossibleBeginningOfExpression[Token`LongName`LeftBracketingBar] = True
isPossibleBeginningOfExpression[Token`LongName`LeftDoubleBracketingBar] = True
isPossibleBeginningOfExpression[Token`LongName`LeftAssociation] = True
isPossibleBeginningOfExpression[Token`LongName`OpenCurlyQuote] = True
isPossibleBeginningOfExpression[Token`LongName`OpenCurlyDoubleQuote] = True
isPossibleBeginningOfExpression[Token`LinearSyntax`OpenParen] = True

isPossibleBeginningOfExpression[Token`LinearSyntax`Bang] = True

isPossibleBeginningOfExpression[Token`LongName`Integral] = True
isPossibleBeginningOfExpression[Token`LongName`ContourIntegral] = True
isPossibleBeginningOfExpression[Token`LongName`DoubleContourIntegral] = True
isPossibleBeginningOfExpression[Token`LongName`ClockwiseContourIntegral] = True
isPossibleBeginningOfExpression[Token`LongName`CounterClockwiseContourIntegral] = True

isPossibleBeginningOfExpression[Token`LongName`Not] = True
isPossibleBeginningOfExpression[Token`LongName`PlusMinus] = True
isPossibleBeginningOfExpression[Token`LongName`Sum] = True
isPossibleBeginningOfExpression[Token`LongName`ForAll] = True
isPossibleBeginningOfExpression[Token`LongName`Exists] = True
isPossibleBeginningOfExpression[Token`LongName`NotExists] = True
isPossibleBeginningOfExpression[Token`LongName`Del] = True
isPossibleBeginningOfExpression[Token`LongName`Product] = True
isPossibleBeginningOfExpression[Token`LongName`Coproduct] = True
isPossibleBeginningOfExpression[Token`LongName`Minus] = True
isPossibleBeginningOfExpression[Token`LongName`MinusPlus] = True
isPossibleBeginningOfExpression[Token`LongName`Sqrt] = True
isPossibleBeginningOfExpression[Token`LongName`CubeRoot] = True
isPossibleBeginningOfExpression[Token`LongName`CircleTimes] = True
isPossibleBeginningOfExpression[Token`LongName`Piecewise] = True
isPossibleBeginningOfExpression[Token`LongName`InvisiblePrefixScriptBase] = True
isPossibleBeginningOfExpression[Token`LongName`ContinuedFractionK] = True
isPossibleBeginningOfExpression[Token`LongName`ProbabilityPr] = True
isPossibleBeginningOfExpression[Token`LongName`ExpectationE] = True
isPossibleBeginningOfExpression[Token`LongName`CapitalDifferentialD] = True
isPossibleBeginningOfExpression[Token`LongName`DifferentialD] = True
isPossibleBeginningOfExpression[Token`LongName`Square] = True



(*
Anything else
*)
isPossibleBeginningOfExpression[_] = False









isCloser[Token`BarGreater] = True
isCloser[Token`CloseCurly] = True
isCloser[Token`CloseParen] = True
isCloser[Token`CloseSquare] = True
isCloser[Token`LongName`CloseCurlyDoubleQuote] = True
isCloser[Token`LongName`CloseCurlyQuote] = True
isCloser[Token`LongName`RightAngleBracket] = True
isCloser[Token`LongName`RightAssociation] = True
isCloser[Token`LongName`RightBracketingBar] = True
isCloser[Token`LongName`RightCeiling] = True
isCloser[Token`LongName`RightDoubleBracket] = True
isCloser[Token`LongName`RightDoubleBracketingBar] = True
isCloser[Token`LongName`RightFloor] = True
isCloser[Token`LinearSyntax`CloseParen] = True

isCloser[_] = False





isError[Token`Error`Unknown] = True
isError[Token`Error`ExpectedEqual] = True
isError[Token`Error`UnhandledDot] = True
isError[Token`Error`UnhandledCharacter] = True
isError[Token`Error`ExpectedLetterlike] = True
isError[Token`Error`UnterminatedComment] = True
isError[Token`Error`UnterminatedString] = True
isError[Token`Error`InvalidBase] = True
isError[Token`Error`ExpectedAccuracy] = True
isError[Token`Error`ExpectedExponent] = True
isError[Token`Error`EmptyString] = True
isError[Token`Error`Aborted] = True
isError[Token`Error`ExpectedOperand] = True
isError[Token`Error`UnrecognizedDigit] = True
isError[Token`Error`ExpectedDigit] = True
isError[Token`Error`UnsupportedCharacter] = True
isError[Token`Error`End] = True

isError[_] = False





isTrivia[Token`Comment] = True
isTrivia[Token`ToplevelNewline] = True
isTrivia[Token`InternalNewline] = True
isTrivia[Token`Whitespace] = True
isTrivia[Token`LineContinuation] = True

isTrivia[_] = False





(*
Actual infix operators, not binary operators
*)

isInfixOperator[Token`AmpAmp] = True
isInfixOperator[Token`AtStar] = True
isInfixOperator[Token`BangEqual] = True
isInfixOperator[Token`Bar] = True
isInfixOperator[Token`BarBar] = True
isInfixOperator[Token`ColonColon] = True
isInfixOperator[Token`Comma] = True
isInfixOperator[Token`Dot] = True
isInfixOperator[Token`EqualBangEqual] = True
isInfixOperator[Token`EqualEqual] = True
isInfixOperator[Token`EqualEqualEqual] = True
isInfixOperator[Token`Greater] = True
isInfixOperator[Token`GreaterEqual] = True
isInfixOperator[Token`Less] = True
isInfixOperator[Token`LessEqual] = True
isInfixOperator[Token`LessGreater] = True
isInfixOperator[Token`Plus] = True
isInfixOperator[Token`Semi] = True
isInfixOperator[Token`SlashStar] = True
isInfixOperator[Token`Star] = True
isInfixOperator[Token`StarStar] = True
isInfixOperator[Token`TildeTilde] = True

isInfixOperator[Token`LongName`And] = True
isInfixOperator[Token`LongName`Backslash] = True
isInfixOperator[Token`LongName`Cap] = True
isInfixOperator[Token`LongName`CenterDot] = True
isInfixOperator[Token`LongName`CircleDot] = True
isInfixOperator[Token`LongName`CirclePlus] = True
isInfixOperator[Token`LongName`CircleTimes] = True
isInfixOperator[Token`LongName`Colon] = True
isInfixOperator[Token`LongName`Conditioned] = True
isInfixOperator[Token`LongName`Congruent] = True
isInfixOperator[Token`LongName`Coproduct] = True
isInfixOperator[Token`LongName`Cross] = True
isInfixOperator[Token`LongName`Cup] = True

isInfixOperator[Token`LongName`CupCap] = True
isInfixOperator[Token`LongName`NotCupCap] = True

isInfixOperator[Token`LongName`Diamond] = True
isInfixOperator[Token`LongName`Distributed] = True
isInfixOperator[Token`LongName`Divides] = True
isInfixOperator[Token`LongName`DotEqual] = True
isInfixOperator[Token`LongName`DoubleDownArrow] = True
isInfixOperator[Token`LongName`DoubleLeftArrow] = True
isInfixOperator[Token`LongName`DoubleLeftRightArrow] = True
isInfixOperator[Token`LongName`DoubleLongLeftArrow] = True
isInfixOperator[Token`LongName`DoubleLongLeftRightArrow] = True
isInfixOperator[Token`LongName`DoubleLongRightArrow] = True
isInfixOperator[Token`LongName`DoubleRightArrow] = True
isInfixOperator[Token`LongName`DoubleUpArrow] = True
isInfixOperator[Token`LongName`DoubleUpDownArrow] = True
isInfixOperator[Token`LongName`DownArrowBar] = True
isInfixOperator[Token`LongName`DownArrowUpArrow] = True
isInfixOperator[Token`LongName`DownLeftRightVector] = True
isInfixOperator[Token`LongName`DownLeftTeeVector] = True
isInfixOperator[Token`LongName`DownLeftVector] = True
isInfixOperator[Token`LongName`DownLeftVectorBar] = True
isInfixOperator[Token`LongName`DownRightTeeVector] = True
isInfixOperator[Token`LongName`DownRightVector] = True
isInfixOperator[Token`LongName`DownRightVectorBar] = True
isInfixOperator[Token`LongName`DownTeeArrow] = True
isInfixOperator[Token`LongName`Element] = True
isInfixOperator[Token`LongName`Equal] = True
isInfixOperator[Token`LongName`EqualTilde] = True
isInfixOperator[Token`LongName`Equilibrium] = True
isInfixOperator[Token`LongName`Equivalent] = True

isInfixOperator[Token`LongName`LessEqualGreater] = True
isInfixOperator[Token`LongName`GreaterEqualLess] = True

isInfixOperator[Token`LongName`GreaterFullEqual] = True
isInfixOperator[Token`LongName`NotGreaterFullEqual] = True

isInfixOperator[Token`LongName`GreaterGreater] = True

isInfixOperator[Token`LongName`GreaterLess] = True
isInfixOperator[Token`LongName`LessGreater] = True
isInfixOperator[Token`LongName`NotGreaterLess] = True
isInfixOperator[Token`LongName`NotLessGreater] = True

isInfixOperator[Token`LongName`GreaterSlantEqual] = True

isInfixOperator[Token`LongName`LessTilde] = True
isInfixOperator[Token`LongName`GreaterTilde] = True
isInfixOperator[Token`LongName`NotLessTilde] = True
isInfixOperator[Token`LongName`NotGreaterTilde] = True

isInfixOperator[Token`LongName`HumpDownHump] = True
isInfixOperator[Token`LongName`HumpEqual] = True
isInfixOperator[Token`LongName`ImplicitPlus] = True
isInfixOperator[Token`LongName`Intersection] = True
isInfixOperator[Token`LongName`InvisibleComma] = True
isInfixOperator[Token`LongName`InvisibleTimes] = True
isInfixOperator[Token`LongName`LeftArrow] = True
isInfixOperator[Token`LongName`LeftArrowBar] = True
isInfixOperator[Token`LongName`LeftArrowRightArrow] = True
isInfixOperator[Token`LongName`LeftDownTeeVector] = True
isInfixOperator[Token`LongName`LeftDownVector] = True
isInfixOperator[Token`LongName`LeftDownVectorBar] = True
isInfixOperator[Token`LongName`LeftRightArrow] = True
isInfixOperator[Token`LongName`LeftRightVector] = True
isInfixOperator[Token`LongName`LeftTeeArrow] = True
isInfixOperator[Token`LongName`LeftTeeVector] = True

isInfixOperator[Token`LongName`LeftTriangle] = True
isInfixOperator[Token`LongName`RightTriangle] = True
isInfixOperator[Token`LongName`NotLeftTriangle] = True
isInfixOperator[Token`LongName`NotRightTriangle] = True

isInfixOperator[Token`LongName`LeftTriangleEqual] = True
isInfixOperator[Token`LongName`RightTriangleEqual] = True
isInfixOperator[Token`LongName`NotLeftTriangleEqual] = True
isInfixOperator[Token`LongName`NotRightTriangleEqual] = True

isInfixOperator[Token`LongName`LeftUpDownVector] = True
isInfixOperator[Token`LongName`LeftUpTeeVector] = True
isInfixOperator[Token`LongName`LeftUpVector] = True
isInfixOperator[Token`LongName`LeftUpVectorBar] = True
isInfixOperator[Token`LongName`LeftVector] = True
isInfixOperator[Token`LongName`LeftVectorBar] = True

isInfixOperator[Token`LongName`LessEqual] = True
isInfixOperator[Token`LongName`GreaterEqual] = True
isInfixOperator[Token`LongName`NotLessEqual] = True
isInfixOperator[Token`LongName`NotGreaterEqual] = True

isInfixOperator[Token`LongName`LessFullEqual] = True
isInfixOperator[Token`LongName`NotLessFullEqual] = True

isInfixOperator[Token`LongName`LessLess] = True
isInfixOperator[Token`LongName`LessSlantEqual] = True
isInfixOperator[Token`LongName`LongEqual] = True
isInfixOperator[Token`LongName`LongLeftArrow] = True
isInfixOperator[Token`LongName`LongLeftRightArrow] = True
isInfixOperator[Token`LongName`LongRightArrow] = True
isInfixOperator[Token`LongName`LowerLeftArrow] = True
isInfixOperator[Token`LongName`LowerRightArrow] = True
isInfixOperator[Token`LongName`Nand] = True
isInfixOperator[Token`LongName`NestedGreaterGreater] = True

isInfixOperator[Token`LongName`NestedLessLess] = True
isInfixOperator[Token`LongName`NotNestedLessLess] = True

isInfixOperator[Token`LongName`Nor] = True
isInfixOperator[Token`LongName`NotCongruent] = True
isInfixOperator[Token`LongName`NotElement] = True
isInfixOperator[Token`LongName`NotEqual] = True
isInfixOperator[Token`LongName`NotEqualTilde] = True
isInfixOperator[Token`LongName`NotGreaterGreater] = True
isInfixOperator[Token`LongName`NotGreaterSlantEqual] = True
isInfixOperator[Token`LongName`NotHumpDownHump] = True
isInfixOperator[Token`LongName`NotHumpEqual] = True

isInfixOperator[Token`LongName`LeftTriangleBar] = True
isInfixOperator[Token`LongName`RightTriangleBar] = True

isInfixOperator[Token`LongName`NotLeftTriangleBar] = True

isInfixOperator[Token`LongName`NotLess] = True
isInfixOperator[Token`LongName`NotGreater] = True

isInfixOperator[Token`LongName`NotLessLess] = True
isInfixOperator[Token`LongName`NotLessSlantEqual] = True
isInfixOperator[Token`LongName`NotNestedGreaterGreater] = True
isInfixOperator[Token`LongName`NotNestedLessLess] = True

isInfixOperator[Token`LongName`NotReverseElement] = True
isInfixOperator[Token`LongName`NotRightTriangleBar] = True

isInfixOperator[Token`LongName`SquareSubset] = True
isInfixOperator[Token`LongName`SquareSuperset] = True
isInfixOperator[Token`LongName`NotSquareSubset] = True
isInfixOperator[Token`LongName`NotSquareSuperset] = True
isInfixOperator[Token`LongName`SquareSubsetEqual] = True
isInfixOperator[Token`LongName`SquareSupersetEqual] = True
isInfixOperator[Token`LongName`NotSquareSubsetEqual] = True
isInfixOperator[Token`LongName`NotSquareSupersetEqual] = True

isInfixOperator[Token`LongName`NotSubset] = True
isInfixOperator[Token`LongName`NotSubsetEqual] = True
isInfixOperator[Token`LongName`NotSuperset] = True
isInfixOperator[Token`LongName`NotSupersetEqual] = True
isInfixOperator[Token`LongName`NotTilde] = True
isInfixOperator[Token`LongName`NotTildeEqual] = True
isInfixOperator[Token`LongName`NotTildeFullEqual] = True
isInfixOperator[Token`LongName`NotTildeTilde] = True
isInfixOperator[Token`LongName`Or] = True
isInfixOperator[Token`LongName`PermutationProduct] = True

isInfixOperator[Token`LongName`Precedes] = True
isInfixOperator[Token`LongName`Succeeds] = True
isInfixOperator[Token`LongName`PrecedesEqual] = True
isInfixOperator[Token`LongName`SucceedsEqual] = True
isInfixOperator[Token`LongName`PrecedesTilde] = True
isInfixOperator[Token`LongName`SucceedsTilde] = True
isInfixOperator[Token`LongName`PrecedesSlantEqual] = True
isInfixOperator[Token`LongName`SucceedsSlantEqual] = True
isInfixOperator[Token`LongName`NotPrecedes] = True
isInfixOperator[Token`LongName`NotSucceeds] = True
isInfixOperator[Token`LongName`NotPrecedesEqual] = True
isInfixOperator[Token`LongName`NotSucceedsEqual] = True
isInfixOperator[Token`LongName`NotPrecedesTilde] = True
isInfixOperator[Token`LongName`NotSucceedsTilde] = True
isInfixOperator[Token`LongName`NotPrecedesSlantEqual] = True
isInfixOperator[Token`LongName`NotSucceedsSlantEqual] = True

isInfixOperator[Token`LongName`Proportion] = True
isInfixOperator[Token`LongName`Proportional] = True
isInfixOperator[Token`LongName`ReverseElement] = True
isInfixOperator[Token`LongName`ReverseEquilibrium] = True
isInfixOperator[Token`LongName`ReverseUpEquilibrium] = True
isInfixOperator[Token`LongName`RightArrow] = True
isInfixOperator[Token`LongName`RightArrowBar] = True
isInfixOperator[Token`LongName`RightArrowLeftArrow] = True
isInfixOperator[Token`LongName`RightDownTeeVector] = True
isInfixOperator[Token`LongName`RightDownVector] = True
isInfixOperator[Token`LongName`RightDownVectorBar] = True
isInfixOperator[Token`LongName`RightTeeArrow] = True
isInfixOperator[Token`LongName`RightTeeVector] = True

isInfixOperator[Token`LongName`RightUpDownVector] = True
isInfixOperator[Token`LongName`RightUpTeeVector] = True
isInfixOperator[Token`LongName`RightUpVector] = True
isInfixOperator[Token`LongName`RightUpVectorBar] = True
isInfixOperator[Token`LongName`RightVector] = True
isInfixOperator[Token`LongName`RightVectorBar] = True
isInfixOperator[Token`LongName`ShortDownArrow] = True
isInfixOperator[Token`LongName`ShortLeftArrow] = True
isInfixOperator[Token`LongName`ShortRightArrow] = True
isInfixOperator[Token`LongName`ShortUpArrow] = True
isInfixOperator[Token`LongName`SmallCircle] = True
isInfixOperator[Token`LongName`Star] = True
isInfixOperator[Token`LongName`Subset] = True
isInfixOperator[Token`LongName`SubsetEqual] = True
isInfixOperator[Token`LongName`Superset] = True
isInfixOperator[Token`LongName`SupersetEqual] = True
isInfixOperator[Token`LongName`TensorProduct] = True
isInfixOperator[Token`LongName`TensorWedge] = True
isInfixOperator[Token`LongName`Tilde] = True
isInfixOperator[Token`LongName`TildeEqual] = True
isInfixOperator[Token`LongName`TildeFullEqual] = True
isInfixOperator[Token`LongName`TildeTilde] = True
isInfixOperator[Token`LongName`Times] = True
isInfixOperator[Token`LongName`Union] = True
isInfixOperator[Token`LongName`UnionPlus] = True

isInfixOperator[Token`LongName`UpArrow] = True
isInfixOperator[Token`LongName`DownArrow] = True

isInfixOperator[Token`LongName`UpArrowBar] = True
isInfixOperator[Token`LongName`UpArrowDownArrow] = True
isInfixOperator[Token`LongName`UpDownArrow] = True
isInfixOperator[Token`LongName`UpEquilibrium] = True
isInfixOperator[Token`LongName`UpperLeftArrow] = True
isInfixOperator[Token`LongName`UpperRightArrow] = True
isInfixOperator[Token`LongName`UpTeeArrow] = True
isInfixOperator[Token`LongName`VectorGreater] = True
isInfixOperator[Token`LongName`VectorGreaterEqual] = True
isInfixOperator[Token`LongName`VectorLess] = True
isInfixOperator[Token`LongName`VectorLessEqual] = True
isInfixOperator[Token`LongName`Vee] = True
isInfixOperator[Token`LongName`VerticalSeparator] = True
isInfixOperator[Token`LongName`VerticalTilde] = True
isInfixOperator[Token`LongName`Wedge] = True
isInfixOperator[Token`LongName`Xor] = True

isInfixOperator[Token`LongName`VerticalBar] = True
isInfixOperator[Token`LongName`DoubleVerticalBar] = True
isInfixOperator[Token`LongName`NotVerticalBar] = True
isInfixOperator[Token`LongName`NotDoubleVerticalBar] = True

isInfixOperator[Token`Fake`ImplicitTimes] = True

isInfixOperator[_] = False







isEmpty[Token`EndOfFile] = True
isEmpty[Token`Fake`ImplicitTimes] = True
isEmpty[Token`Error`EmptyString] = True
isEmpty[Token`Error`Aborted] = True
isEmpty[Token`Fake`ImplicitNull] = True
isEmpty[Token`Fake`ImplicitOne] = True
isEmpty[Token`Fake`ImplicitAll] = True
isEmpty[Token`Error`ExpectedOperand] = True
(*
isEmpty[Token`ToplevelNewline] = True
isEmpty[Token`InternalNewline] = True
*)

isEmpty[_] = False




isDifferentialD[Token`LongName`DifferentialD] = True
isDifferentialD[Token`LongName`CapitalDifferentialD] = True

isDifferentialD[_] = False






group1Bits[tok_] := group1Bits[tok] =
Which[
  isPossibleBeginningOfExpression[tok], BitShiftLeft[2^^001, 9],
  isCloser[tok],                        BitShiftLeft[2^^010, 9],
  isError[tok],                         BitShiftLeft[2^^011, 9],
  isTrivia[tok],                        BitShiftLeft[2^^100, 9],
  isInfixOperator[tok],                 BitShiftLeft[2^^101, 9],
  (* unused                             BitShiftLeft[2^^110, 9],*)
  (* unused                             BitShiftLeft[2^^111, 9],*)

  True,                                 BitShiftLeft[2^^000, 9]
]



group2Bits[tok_] := group2Bits[tok] =
Which[
  isEmpty[tok],         BitShiftLeft[2^^01, 12],
  isDifferentialD[tok], BitShiftLeft[2^^10, 12],
  (* unused             BitShiftLeft[2^^11, 12],*)

  True,                 BitShiftLeft[2^^00, 12]
]




Print["Generating TokenEnum..."]


cur = 0
enumMap = <||>
KeyValueMap[(
  Which[
    #2 === 0, cur = 0,
    #2 === Next, cur++,
    True, cur = enumMap[#2]
  ];
  AssociateTo[enumMap, #1 -> cur])&
  ,
  importedTokenEnumSource
]

(*
sanity check that all tokens are in order
*)
cur = -Infinity;
KeyValueMap[
  If[!TrueQ[#2 >= cur],
    Print["Token is out of order: ", #1->#2];
    Quit[1]
    ,
    cur = #2
  ]&
  ,
  enumMap
]



tokenCPPHeader = {
"
//
// AUTO GENERATED FILE
// DO NOT MODIFY
//

#pragma once

#include <cstdint> // for uint16_t

enum Closer : uint8_t {
    CLOSER_UNKNOWN,
    CLOSER_BARGREATER,
    CLOSER_CLOSECURLY,
    CLOSER_CLOSEPAREN,
    CLOSER_CLOSESQUARE,
    CLOSER_LONGNAME_CLOSECURLYDOUBLEQUOTE,
    CLOSER_LONGNAME_CLOSECURLYQUOTE,
    CLOSER_LONGNAME_RIGHTANGLEBRACKET,
    CLOSER_LONGNAME_RIGHTASSOCIATION,
    CLOSER_LONGNAME_RIGHTBRACKETINGBAR,
    CLOSER_LONGNAME_RIGHTCEILING,
    CLOSER_LONGNAME_RIGHTDOUBLEBRACKET,
    CLOSER_LONGNAME_RIGHTDOUBLEBRACKETINGBAR,
    CLOSER_LONGNAME_RIGHTFLOOR,
    CLOSER_LINEARSYNTAX_CLOSEPAREN,
    CLOSER_ASSERTFALSE,
};

struct TokenEnum {

  uint16_t T;

  constexpr TokenEnum() : T(0) {}

  constexpr TokenEnum(uint16_t T) : T(T) {}

  constexpr uint16_t value() const {
    return (T & 0x1ff);
  }

  constexpr uint16_t t() const {
    return T;
  }

  constexpr bool isPossibleBeginningOfExpression() const {
      return static_cast<bool>((T & 0xe00) == 0x200);
  }
  
  constexpr bool isCloser() const {
      return static_cast<bool>((T & 0xe00) == 0x400);
  }
  
  constexpr bool isError() const {
      return static_cast<bool>((T & 0xe00) == 0x600);
  }
  
  constexpr bool isTrivia() const {
      return static_cast<bool>((T & 0xe00) == 0x800);
  }

  constexpr bool isInfixOperator() const {
      return static_cast<bool>((T & 0xe00) == 0xa00);
  }

  constexpr bool isEmpty() const {
      return static_cast<bool>((T & 0x3000) == 0x1000);
  }

  constexpr bool isDifferentialD() const {
      return static_cast<bool>((T & 0x3000) == 0x2000);
  }

};

bool operator==(TokenEnum a, TokenEnum b);

bool operator!=(TokenEnum a, TokenEnum b);
"} ~Join~
KeyValueMap[(
  Row[{"constexpr TokenEnum ", toGlobal[#1], "(",
    BitOr[
      group2Bits[#1],
      group1Bits[#1],
      #2
    ], "); // { group2Bits:", group2Bits[#1], ", group1Bits:", group1Bits[#1], ", enum:", #2, " }"
  }])&
  ,
  enumMap
] ~Join~ {
}

Print["exporting TokenEnum.h"]
res = Export[FileNameJoin[{generatedCPPIncludeDir, "TokenEnum.h"}], Column[tokenCPPHeader], "String"]

If[FailureQ[res],
  Print[res];
  Quit[1]
]



tokenToSymbolCases = Row[{"case ", toGlobal[#], ".value(): return ", toGlobal[tokenToSymbol[#]], ";"}]& /@ tokens


tokenCPPSource = {
"
//
// AUTO GENERATED FILE
// DO NOT MODIFY
//

#include \"TokenEnum.h\"

#include \"Symbol.h\"
#include \"Token.h\"

#include <cassert>

//
// TOKEN_TOPLEVELNEWLINE must be 0 % 2 to allow setting the 1 bit to convert to TOKEN_INTERNALNEWLINE
//
static_assert(TOKEN_TOPLEVELNEWLINE.value() % 2 == 0, \"Check your assumptions\");
static_assert(TOKEN_INTERNALNEWLINE.value() % 2 == 1, \"Check your assumptions\");
"} ~Join~
{"SymbolPtr& TokenToSymbol(TokenEnum T) {"} ~Join~
{"switch (T.value()) {"} ~Join~
tokenToSymbolCases ~Join~
{"default:"} ~Join~
{"assert(false && \"Unhandled token type\"); return SYMBOL_TOKEN_UNKNOWN;"} ~Join~
{"}"} ~Join~
{"}"} ~Join~
{""} ~Join~
{"bool operator==(TokenEnum a, TokenEnum b) {
  return a.value() == b.value();
}

bool operator!=(TokenEnum a, TokenEnum b) {
  return a.value() != b.value();
}
"}

Print["exporting TokenEnum.cpp"]
res = Export[FileNameJoin[{generatedCPPSrcDir, "TokenEnum.cpp"}], Column[tokenCPPSource], "String"]

If[FailureQ[res],
  Print[res];
  Quit[1]
]

Print["Done Token"]

End[]

EndPackage[]
