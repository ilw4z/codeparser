BeginPackage["AST`Abstract`"]

Abstract::usage = "Abstract[concrete] returns an abstract syntax tree from a concrete syntax tree."

Begin["`Private`"]

Needs["AST`"]
Needs["AST`Utils`"]


Abstract[s_SymbolNode] := s
Abstract[s_StringNode] := s
Abstract[n_NumberNode] := n



Abstract[SlotNode["#", {}, data_]] := CallNode[ToNode[Slot], {ToNode[1]}, data]
Abstract[SlotNode[str_ /; StringMatchQ[str, "#"~~DigitCharacter..], {}, data_]] := CallNode[ToNode[Slot], {ToNode[FromDigits[StringDrop[str, 1]]]}, data]
Abstract[SlotNode[str_, {}, data_]] := CallNode[ToNode[Slot], {ToNode[StringDrop[str, 1]]}, data]
Abstract[SlotSequenceNode["##", {}, data_]] := CallNode[ToNode[SlotSequence], {ToNode[1]}, data]
Abstract[SlotSequenceNode[str_ /; StringMatchQ[str, "##"~~DigitCharacter..], {}, data_]] := CallNode[ToNode[SlotSequence], {ToNode[FromDigits[StringDrop[str, 2]]]}, data]
Abstract[OutNode["%", {}, data_]] := CallNode[ToNode[Out], {}, data]




Abstract[PrefixNode[Minus, {op_}, data_]] := Abstract[negate[op]]
Abstract[PrefixNode[PrefixLinearSyntaxBang, children:{Except[GroupNode[GroupLinearSyntaxParen, _, _]]}, data_]] := SyntaxErrorNode[Token`Operator`LinearSyntax`Bang, children, data]
(* keep linear syntax for now *)
Abstract[prefix:PrefixNode[PrefixLinearSyntaxBang, children_, data_]] := prefix
Abstract[PrefixNode[op_, {operand_}, data_]] := CallNode[ToNode[op], {Abstract[operand]}, data]


Abstract[deriv:PostfixNode[Derivative, {operand_}, data_]] := abstractDerivative[deriv]
Abstract[PostfixNode[op_, {operand_}, data_]] := CallNode[ToNode[op], {Abstract[operand]}, data]




Abstract[minus:BinaryNode[Minus, _, _]] := abstractPlus[minus]
Abstract[times:BinaryNode[Divide, _, _]] := abstractTimes[times]

Abstract[inequality:BinaryNode[Equal, _, _]] := abstractInequality[inequality]
Abstract[inequality:BinaryNode[Unequal, _, _]] := abstractInequality[inequality]
Abstract[inequality:BinaryNode[Less, _, _]] := abstractInequality[inequality]
Abstract[inequality:BinaryNode[Greater, _, _]] := abstractInequality[inequality]
Abstract[inequality:BinaryNode[LessEqual, _, _]] := abstractInequality[inequality]
Abstract[inequality:BinaryNode[GreaterEqual, _, _]] := abstractInequality[inequality]
Abstract[BinaryNode[BinaryAt, {left_, right_}, data_]] := CallNode[Abstract[left], {Abstract[right]}, data]
Abstract[BinaryNode[BinaryAtAtAt, {left_, right_}, data_]] := CallNode[ToNode[Apply], Abstract /@ {left, right, GroupNode[List, {ToNode[1]}, <||>]}, data]
Abstract[BinaryNode[BinarySlashSlash, {left_, right_}, data_]] := CallNode[Abstract[right], {Abstract[left]}, data]

Abstract[sameq:BinaryNode[SameQ, _, _]] := abstractSameQ[sameq]
Abstract[unsameq:BinaryNode[UnsameQ, _, _]] := abstractUnsameQ[unsameq]
Abstract[comp:BinaryNode[Composition, _, _]] := abstractComposition[comp]
Abstract[comp:BinaryNode[RightComposition, _, _]] := abstractRightComposition[comp]

(* NonAssociative errors *)
Abstract[BinaryNode[PatternTest, children:{BinaryNode[PatternTest, _, _], _}, data_]] := SyntaxErrorNode[Token`Operator`Question, children, data]
Abstract[BinaryNode[DirectedEdge, children:{BinaryNode[DirectedEdge, _, _], _}, data_]] := SyntaxErrorNode[Token`Operator`LongName`DirectedEdge, children, data]
Abstract[BinaryNode[UndirectedEdge, children:{BinaryNode[UndirectedEdge, _, _], _}, data_]] := SyntaxErrorNode[Token`Operator`LongName`UndirectedEdge, children, data]

Abstract[BinaryNode[Span, {InternalOneNode[1, {}, _], InternalAllNode[All, {}, _]}, data_]] := CallNode[ToNode[Span], {ToNode[1], ToNode[All]}, data]
Abstract[BinaryNode[Span, {left_, InternalAllNode[All, {}, _]}, data_]] := CallNode[ToNode[Span], {Abstract[left], ToNode[All]}, data]
Abstract[BinaryNode[Span, {InternalOneNode[1, {}, _], right_}, data_]] := CallNode[ToNode[Span], {ToNode[1], Abstract[right]}, data]

Abstract[BinaryNode[Unset, {left_, InternalDotNode[Dot, {}, _]}, data_]] := CallNode[ToNode[Unset], {Abstract[left]}, data]

Abstract[BinaryNode[op_, {left_, right_}, data_]] := CallNode[ToNode[op], {Abstract[left], Abstract[right]}, data]




Abstract[plus:InfixNode[Plus, _, _]] := abstractPlus[plus]
Abstract[plus:InfixNode[InfixImplicitPlus, _, _]] := abstractPlus[plus]
Abstract[times:InfixNode[Times, _, _]] := abstractTimes[times]
Abstract[times:InfixNode[ImplicitTimes, _, _]] := abstractTimes[times]
Abstract[times:InfixNode[InfixInvisibleTimes, _, _]] := abstractTimes[times]
Abstract[times:InfixNode[InfixTimes, _, _]] := abstractTimes[times]

Abstract[and:InfixNode[And, _, _]] := abstractAnd[and]
Abstract[or:InfixNode[Or, _, _]] := abstractOr[or]

Abstract[divisible:InfixNode[Divisible, _, _]] := abstractDivisible[divisible]

Abstract[compound:InfixNode[CompoundExpression, _, _]] := abstractCompoundExpression[compound]
Abstract[stringJoin:InfixNode[StringJoin, _, _]] := abstractStringJoin[stringJoin]
Abstract[InfixNode[op_, nodes_, data_]] := CallNode[ToNode[op], Abstract /@ nodes, data]






Abstract[TernaryNode[TernaryTilde, {left_, middle_, right_}, data_]] := CallNode[Abstract[middle], {Abstract[left], Abstract[right]}, data]

Abstract[TernaryNode[TagSet, {left_, middle_, right_}, data_]] := CallNode[ToNode[TagSet], {Abstract[left], Abstract[middle], Abstract[right]}, data]
Abstract[TernaryNode[TagSetDelayed, {left_, middle_, right_}, data_]] := CallNode[ToNode[TagSetDelayed], {Abstract[left], Abstract[middle], Abstract[right]}, data]
Abstract[TernaryNode[TagUnset, {left_, middle_, InternalDotNode[Dot, {}, _]}, data_]] := CallNode[ToNode[TagUnset], {Abstract[left], Abstract[middle]}, data]

Abstract[TernaryNode[Span, {InternalOneNode[1, {}, _], InternalAllNode[All, {}, _], right_}, data_]] := CallNode[ToNode[Span], {ToNode[1], ToNode[All], Abstract[right]}, data]
Abstract[TernaryNode[Span, {InternalOneNode[1, {}, _], middle_, right_}, data_]] := CallNode[ToNode[Span], {ToNode[1], Abstract[middle], Abstract[right]}, data]
Abstract[TernaryNode[Span, {left_, InternalAllNode[All, {}, _], right_}, data_]] := CallNode[ToNode[Span], {Abstract[left], ToNode[All], Abstract[right]}, data]
Abstract[TernaryNode[Span, {left_, middle_, right_}, data_]] := CallNode[ToNode[Span], {Abstract[left], Abstract[middle], Abstract[right]}, data]

Abstract[TernaryNode[MessageName, {left_, middle_, right_}, data_]] := CallNode[ToNode[MessageName], {Abstract[left], Abstract[middle], Abstract[right]}, data]




(* handle CallNode before possible GroupNode errors *)
Abstract[call_CallNode] := abstractCallNode[call]
Abstract[call_CallMissingCloserNode] := abstractCallNode[call]


(*
take care of specific GroupNodes before calling abstractGroupNode
*)
Abstract[GroupNode[GroupParen, {child_}, data_]] := Abstract[child]

(* GroupNode errors *)
Abstract[GroupNode[GroupSquare, children_, data_]] := SyntaxErrorNode[Token`Operator`OpenSquare, children, data]
Abstract[GroupNode[GroupParen, children_, data_]] := SyntaxErrorNode[Token`Operator`OpenParen, children, data]

(*
skip abstracting linear syntax for now
GroupLinearSyntaxParen retains its commas, so handle before abstractGroupNode
*)
Abstract[group:GroupNode[GroupLinearSyntaxParen, children_, data_]] := group
Abstract[group_GroupNode] := abstractGroupNode[group]




Abstract[BlankNode[Blank, {}, data_]] := CallNode[ToNode[Blank], {}, data]
Abstract[BlankNode[Blank, {sym2_}, data_]] := CallNode[ToNode[Blank], {sym2}, data]
Abstract[BlankSequenceNode[BlankSequence, {}, data_]] := CallNode[ToNode[BlankSequence], {}, data]
Abstract[BlankSequenceNode[BlankSequence, {sym2_}, data_]] := CallNode[ToNode[BlankSequence], {sym2}, data]
Abstract[BlankNullSequenceNode[BlankNullSequence, {}, data_]] := CallNode[ToNode[BlankNullSequence], {}, data]
Abstract[BlankNullSequenceNode[BlankNullSequence, {sym2_}, data_]] := CallNode[ToNode[BlankNullSequence], {sym2}, data]
Abstract[OptionalDefaultNode[OptionalDefault, {}, data_]] := CallNode[ToNode[Optional], {CallNode[ToNode[Blank], {}, <||>]}, data]

Abstract[PatternBlankNode[PatternBlank, {sym1_}, data_]] := CallNode[ToNode[Pattern], {sym1, CallNode[ToNode[Blank], {}, <||>]}, data]
Abstract[PatternBlankNode[PatternBlank, {sym1_, sym2_}, data_]] := CallNode[ToNode[Pattern], {sym1, CallNode[ToNode[Blank], {sym2}, <||>]}, data]
Abstract[PatternBlankSequenceNode[PatternBlankSequence, {sym1_}, data_]] := CallNode[ToNode[Pattern], {sym1, CallNode[ToNode[BlankSequence], {}, <||>]}, data]
Abstract[PatternBlankSequenceNode[PatternBlankSequence, {sym1_, sym2_}, data_]] := CallNode[ToNode[Pattern], {sym1, CallNode[ToNode[BlankSequence], {sym2}, <||>]}, data]
Abstract[PatternBlankNullSequenceNode[PatternBlankNullSequence, {sym1_}, data_]] := CallNode[ToNode[Pattern], {sym1, CallNode[ToNode[BlankNullSequence], {}, <||>]}, data]
Abstract[PatternBlankNullSequenceNode[PatternBlankNullSequence, {sym1_, sym2_}, data_]] := CallNode[ToNode[Pattern], {sym1, CallNode[ToNode[BlankNullSequence], {sym2}, <||>]}, data]
Abstract[OptionalDefaultPatternNode[OptionalDefaultPattern, {sym1_}, data_]] := CallNode[ToNode[Optional], {CallNode[ToNode[Pattern], {sym1, CallNode[ToNode[Blank], {}, <||>]}, <||>]}, data]



Abstract[FileNode[File, children_, data_]] := FileNode[File, Abstract /@ children, data]
Abstract[HoldNode[Hold, children_, data_]] := HoldNode[Hold, Abstract /@ children, data]




(*
Just pass SyntaxErrorNode pass
*)
Abstract[syn_SyntaxErrorNode] := syn



Abstract[f_Failure] := f









(*
concrete syntax does not have negated numbers
abstract syntax is allowed to have negated numbers
*)
negate[NumberNode[str_, {}, data_]] :=
	NumberNode["-"<>str, {}, data]


(*
Important to use InfixNode[Times and not just CallNode[Times,

This allows these nodes to be merged later e.g., 1-a/b
*)

negate[InfixNode[Times, children_, data_]] :=
	InfixNode[Times, {ToNode[-1]}~Join~children, data]

negate[InfixNode[ImplicitTimes, children_, data_]] :=
	InfixNode[Times, {ToNode[-1]}~Join~children, data]

negate[InfixNode[InfixInvisibleTimes, children_, data_]] :=
	InfixNode[Times, {ToNode[-1]}~Join~children, data]

negate[InfixNode[InfixTimes, children_, data_]] :=
	InfixNode[Times, {ToNode[-1]}~Join~children, data]

negate[node_] :=
	InfixNode[Times, {ToNode[-1], node}, node[[3]]]


reciprocate[node_] :=
	CallNode[ToNode[Power], {node, ToNode[-1]}, node[[3]]]




(*
abstract syntax of  +a + b - c \[ImplicitPlus] d  is a single Plus expression
except when it's not, bug 365287
*)
flattenPlus[nodes_List] :=
	Module[{},
		(
			Switch[#,
				PrefixNode[Plus, _, _],
					flattenPlus[{#[[2]][[1]]}]
				,
				InfixNode[Plus, _, _],
					flattenPlus[#[[2]]]
				,
				BinaryNode[Minus, _, _],
					flattenPlus[{First[#[[2]]], negate /@ Rest[#[[2]]]}]
				,
				InfixNode[InfixImplicitPlus, _, _],
					flattenPlus[#[[2]]]
				,
				_,
					#
			]
		)& /@ nodes
	]

abstractPlus[InfixNode[Plus, children_, data_]] :=
	CallNode[ToNode[Plus], Abstract /@ Flatten[flattenPlus[children]], data]

abstractPlus[BinaryNode[Minus, children_, data_]] :=
	CallNode[ToNode[Plus], Abstract /@ Flatten[flattenPlus[{First[children], negate /@ Rest[children]}]], data]

abstractPlus[InfixNode[InfixImplicitPlus, children_, data_]] :=
	CallNode[ToNode[Plus], Abstract /@ Flatten[flattenPlus[children]], data]

(*
abstract syntax of  -a * b / c d \[InvisibleTimes] e \[Times] f  is a single Times expression
*)
flattenTimes[nodes_List] :=
	Module[{},
		(
			Switch[#,
				PrefixNode[Minus, {NumberNode[_, _, _]}, _],
					{negate[#[[2,1]]]}
				,
				PrefixNode[Minus, _, _],
					{ToNode[-1], #[[2]]}
				,
				InfixNode[Times, _, _],
					flattenTimes[#[[2]]]
				,
				BinaryNode[Divide, _, _],
					flattenTimes[{#[[2]][[1]], reciprocate[#[[2]][[2]]]}]
				,
				InfixNode[ImplicitTimes, _, _],
					flattenTimes[#[[2]]]
				,
				InfixNode[InfixInvisibleTimes, _, _],
					flattenTimes[#[[2]]]
				,
				InfixNode[InfixTimes, _, _],
					flattenTimes[#[[2]]]
				,
				_,
					#
			]
		)& /@ nodes
	]

abstractTimes[InfixNode[Times, children_, data_]] :=
	CallNode[ToNode[Times], Abstract /@ Flatten[flattenTimes[children]], data]

abstractTimes[BinaryNode[Divide, children_, data_]] :=
	CallNode[ToNode[Times], Abstract /@ Flatten[flattenTimes[{children[[1]], reciprocate[children[[2]]]}]], data]

abstractTimes[InfixNode[ImplicitTimes, children_, data_]] :=
	CallNode[ToNode[Times], Abstract /@ Flatten[flattenTimes[children]], data]

abstractTimes[InfixNode[InfixInvisibleTimes, children_, data_]] :=
	CallNode[ToNode[Times], Abstract /@ Flatten[flattenTimes[children]], data]

abstractTimes[InfixNode[InfixTimes, children_, data_]] :=
	CallNode[ToNode[Times], Abstract /@ Flatten[flattenTimes[children]], data]





(*
abstract syntax of  a == b != c < d > e <= f >= g  is a single Inequality expression
*)
flattenInequality[nodes_List] :=
	Module[{},
		(
			Switch[#,
				BinaryNode[Equal, _, _],
					flattenInequality[{#[[2]][[1]], ToNode[Equal], #[[2]][[2]]}]
				,
				BinaryNode[Unequal, _, _],
					flattenInequality[{#[[2]][[1]], ToNode[Unequal], #[[2]][[2]]}]
				,
				BinaryNode[Less, _, _],
					flattenInequality[{#[[2]][[1]], ToNode[Less], #[[2]][[2]]}]
				,
				BinaryNode[Greater, _, _],
					flattenInequality[{#[[2]][[1]], ToNode[Greater], #[[2]][[2]]}]
				,
				BinaryNode[LessEqual, _, _],
					flattenInequality[{#[[2]][[1]], ToNode[LessEqual], #[[2]][[2]]}]
				,
				BinaryNode[GreaterEqual, _, _],
					flattenInequality[{#[[2]][[1]], ToNode[GreaterEqual], #[[2]][[2]]}]
				,
				_,
					#
			]
		)& /@ nodes
	]

abstractInequality[BinaryNode[Equal, {left_, right_}, data_]] :=
	simplifyInequality[InfixNode[Inequality, Flatten[flattenInequality[{left, ToNode[Equal], right}]], data]]

abstractInequality[BinaryNode[Unequal, {left_, right_}, data_]] :=
	simplifyInequality[InfixNode[Inequality, Flatten[flattenInequality[{left, ToNode[Unequal], right}]], data]]

abstractInequality[BinaryNode[Less, {left_, right_}, data_]] :=
	simplifyInequality[InfixNode[Inequality, Flatten[flattenInequality[{left, ToNode[Less], right}]], data]]

abstractInequality[BinaryNode[Greater, {left_, right_}, data_]] :=
	simplifyInequality[InfixNode[Inequality, Flatten[flattenInequality[{left, ToNode[Greater], right}]], data]]

abstractInequality[BinaryNode[LessEqual, {left_, right_}, data_]] :=
	simplifyInequality[InfixNode[Inequality, Flatten[flattenInequality[{left, ToNode[LessEqual], right}]], data]]

abstractInequality[BinaryNode[GreaterEqual, {left_, right_}, data_]] :=
	simplifyInequality[InfixNode[Inequality, Flatten[flattenInequality[{left, ToNode[GreaterEqual], right}]], data]]

(*
attempt to simplify e.g. Inequality[a, Less, b, Less, c] to Less[a, b, c]
*)
simplifyInequality[InfixNode[Inequality, children_, data_]] :=
Module[{rators, rands},
	rators = children[[2;;-2;;2]];
	rands = children[[1;;-1;;2]];

	Switch[rators,
		{ToNode[Equal]..},
			CallNode[ToNode[Equal], Abstract /@ rands, data]
		,
		{ToNode[Unequal]..},
			CallNode[ToNode[Unequal], Abstract /@ rands, data]
		,
		{ToNode[Less]..},
			CallNode[ToNode[Less], Abstract /@ rands, data]
		,
		{ToNode[Greater]..},
			CallNode[ToNode[Greater], Abstract /@ rands, data]
		,
		{ToNode[LessEqual]..},
			CallNode[ToNode[LessEqual], Abstract /@ rands, data]
		,
		{ToNode[GreaterEqual]..},
			CallNode[ToNode[GreaterEqual], Abstract /@ rands, data]
		,
		_,
			CallNode[ToNode[Inequality], Abstract /@ children, data]
	]
]





(*
abstract syntax of  a === b === c  is a single SameQ expression
*)
flattenSameQ[nodes_List] :=
	Module[{},
		(
			Switch[#,
				BinaryNode[SameQ, _, _],
					flattenSameQ[#[[2]]]
				,
				_,
					#
			]
		)& /@ nodes
	]

abstractSameQ[BinaryNode[SameQ, children_, data_]] :=
	CallNode[ToNode[SameQ], Abstract /@ Flatten[flattenSameQ[children]], data]



(*
abstract syntax of  a =!= b =!= c  is a single UnsameQ expression
*)
flattenUnsameQ[nodes_List] :=
	Module[{},
		(
			Switch[#,
				BinaryNode[UnsameQ, _, _],
					flattenUnsameQ[#[[2]]]
				,
				_,
					#
			]
		)& /@ nodes
	]

abstractUnsameQ[BinaryNode[UnsameQ, children_, data_]] :=
	CallNode[ToNode[UnsameQ], Abstract /@ Flatten[flattenUnsameQ[children]], data]



(*
abstract syntax of  a @* b @* c  is a single Composition expression
*)
flattenComposition[nodes_List] :=
	Module[{},
		(
			Switch[#,
				BinaryNode[Composition, _, _],
					flattenComposition[#[[2]]]
				,
				_,
					#
			]
		)& /@ nodes
	]

abstractComposition[BinaryNode[Composition, children_, data_]] :=
	CallNode[ToNode[Composition], Abstract /@ Flatten[flattenComposition[children]], data]




(*
abstract syntax of  a /* b /* c  is a single RightComposition expression
*)
flattenRightComposition[nodes_List] :=
	Module[{},
		(
			Switch[#,
				BinaryNode[RightComposition, _, _],
					flattenRightComposition[#[[2]]]
				,
				_,
					#
			]
		)& /@ nodes
	]

abstractRightComposition[BinaryNode[RightComposition, children_, data_]] :=
	CallNode[ToNode[RightComposition], Abstract /@ Flatten[flattenRightComposition[children]], data]





abstractCompoundExpressionChild[InternalNullNode[Null, {}, data_]] :=
	SymbolNode["Null", {}, data]

abstractCompoundExpressionChild[c_] :=
	Abstract[c]

abstractCompoundExpression[InfixNode[CompoundExpression, children_, data_]] :=
	CallNode[ToNode[CompoundExpression], abstractCompoundExpressionChild /@ children, data]






(*
handle "featuroid" bug 365013 where a<>StringJoin@b parses as a<>b
*)

abstractStringJoinChild[BinaryNode[BinaryAt, {SymbolNode["StringJoin", {}, _], c_}, _]] :=
	Abstract[c]

abstractStringJoinChild[c_] :=
	Abstract[c]

abstractStringJoin[InfixNode[StringJoin, children_, data_]] :=
	CallNode[ToNode[StringJoin], abstractStringJoinChild /@ children, data]












(*
abstract syntax of  a && b \[And] c  is a single And expression
*)
flattenAnd[nodes_List] :=
	Module[{},
		(
			Switch[#,
				InfixNode[And, _, _],
					flattenAnd[#[[2]]]
				,
				_,
					#
			]
		)& /@ nodes
	]

abstractAnd[InfixNode[And, children_, data_]] :=
	CallNode[ToNode[And], Abstract /@ Flatten[flattenAnd[children]], data]



(*
abstract syntax of  a || b \[Or] c  is a single Or expression
*)
flattenOr[nodes_List] :=
	Module[{},
		(
			Switch[#,
				InfixNode[Or, _, _],
					flattenOr[#[[2]]]
				,
				_,
					#
			]
		)& /@ nodes
	]

abstractOr[InfixNode[Or, children_, data_]] :=
	CallNode[ToNode[Or], Abstract /@ Flatten[flattenOr[children]], data]



(*
make sure to reverse children of Divisible
*)
abstractDivisible[InfixNode[Divisible, children_, data_]] :=
	CallNode[ToNode[Divisible], Abstract /@ Reverse[children], data]






(*
Collect all of the ' in f'''[x]
*)

derivativeOrderAndBody[PostfixNode[Derivative, {rand_}, data_]] :=
Module[{order, body},
	{order, body} = derivativeOrderAndBody[rand];
	{order+1, body}
]

derivativeOrderAndBody[node_] :=
	{0, Abstract[node]}

abstractDerivative[deriv:PostfixNode[Derivative, {rand_}, data_]] :=
Module[{order, body},
	{order, body} = derivativeOrderAndBody[deriv];
	CallNode[CallNode[ToNode[Derivative], {ToNode[order]}, <||>], {body}, <||>]
]














commaPat = "," | "\\[InvisibleComma]"

(*

Removes all commas

Fills in Nulls and gives SyntaxIssues for e.g. {1,,2}
*)
abstractGroupNode[GroupNode[tag_, children_, dataIn_]] :=
Module[{lastWasComma, abstractedChildren, issues, data},
	data = dataIn;
	issues = {};
	lastWasComma = !empty[children] && MatchQ[children[[1]], InternalTokenNode[commaPat, {}, _]];
	abstractedChildren = (Switch[#,
		InternalTokenNode[commaPat, {}, _],
			If[lastWasComma,
    			AppendTo[issues, SyntaxIssue["SyntaxError", "Comma encountered with no adjacent expression. The expression will be treated as Null", "Error", data]];
    			SymbolNode["Null", {}, <||>]
    			,
    			lastWasComma = True;
    			Nothing
    		]
    	,
    	_,
    		lastWasComma = False;
    		Abstract[#]
   ])& /@ children;
   If[lastWasComma,
   	AppendTo[issues, SyntaxIssue["SyntaxError", "Comma encountered with no adjacent expression. The expression will be treated as Null", "Error", data]];
   	AppendTo[abstractedChildren, SymbolNode["Null", {}, <||>]];
   ];

   If[issues != {},
   	issues = Lookup[data, SyntaxIssues, {}] ~Join~ issues;
   	AssociateTo[data, SyntaxIssues -> issues];
   ];
   
   CallNode[ToNode[tag], abstractedChildren, data]
]



(*

Concrete parse of a[[2]] returns CallNode[a, GroupNode[Square, {GroupNode[Square, {2}]}]]
Abstract parse of a[[2]] returns CallNode[Part, {a, 2}]

So convert from concrete [[ syntax to abstract Part syntax

*)
abstractCallNode[CallNode[headIn_, {outer:GroupNode[GroupSquare, {inner:GroupNode[GroupSquare, _, _]}, _]}, dataIn_]] :=
Module[{head, data, part, innerData, outerData, issues, partData},
	head = headIn;
	data = dataIn;
	part = inner;
	innerData = inner[[3]];
	outerData = outer[[3]];
	issues = {};

	head = Abstract[head];
	part = abstractGroupNode[part];
	partData = part[[3]];

	issues = Lookup[partData, SyntaxIssues, {}] ~Join~ issues;

	If[outerData[Source][[1,2]]+1 != innerData[Source][[1,2]],
		AppendTo[issues, SyntaxIssue["NotContiguous", "Part brackets [[ are not contiguous", "Warning", <|Source->{outerData[Source][[1]], innerData[Source][[1]]}|>]];
	];

	If[innerData[Source][[2,2]]+1 != outerData[Source][[2,2]],
		AppendTo[issues, SyntaxIssue["NotContiguous", "Part brackets ]] are not contiguous", "Warning", <|Source->{innerData[Source][[2]], outerData[Source][[2]]}|>]];
	];

	If[issues != {},
   	issues = Lookup[data, SyntaxIssues, {}] ~Join~ issues;
   	AssociateTo[data, SyntaxIssues -> issues];
   ];

	CallNode[ToNode[Part], {head}~Join~part[[2]], data]
]

(*

Concrete parse of a[2] returns CallNode[a, GroupNode[Square, {2}]]
Abstract parse of a[2] returns CallNode[a, {2}]

So convert from concrete [[ syntax to abstract Part syntax

*)
abstractCallNode[(c:CallNode|CallMissingCloserNode)[headIn_, {partIn:GroupNode[GroupSquare|GroupMissingCloserSquare, _, _]}, dataIn_]] :=
Module[{head, part, partData, issues, data},
	head = headIn;
	part = partIn;
	data = dataIn;

	issues = {};

	head = Abstract[head];
	part = abstractGroupNode[part];
	partData = part[[3]];

	issues = Lookup[partData, SyntaxIssues, {}] ~Join~ issues;

	If[issues != {},
   	issues = Lookup[data, SyntaxIssues, {}] ~Join~ issues;
   	AssociateTo[data, SyntaxIssues -> issues];
   ];

	c[head, part[[2]], data]
]

(*

Concrete parse of a\[LeftDoubleBracket]2\[RightDoubleBracket] returns CallNode[a, GroupNode[DoubleBracket, {2}]]
Abstract parse of a\[LeftDoubleBracket]2\[RightDoubleBracket] returns CallNode[Part, {a, 2}]

*)
abstractCallNode[CallNode[headIn_, {partIn:GroupNode[GroupDoubleBracket, _, _]}, dataIn_]] :=
Module[{head, part, partData, data, issues},
	head = headIn;
	part = partIn;
	data = dataIn;

	issues = {};

	head = Abstract[head];
	part = abstractGroupNode[part];
	partData = part[[3]];

	issues = Lookup[partData, SyntaxIssues, {}] ~Join~ issues;

	If[issues != {},
		issues = Lookup[data, SyntaxIssues, {}] ~Join~ issues;
		AssociateTo[data, SyntaxIssues -> issues];
   ];

	CallNode[ToNode[Part], {head}~Join~(part[[2]]), data]
]


abstractCallNode[CallNode[head_, children_, data_]] :=
	CallNode[Abstract[head], Abstract /@ children, data]


End[]

EndPackage[]
