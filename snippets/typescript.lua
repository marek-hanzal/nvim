local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
	s(
		"schema",
		fmt(
			[[
import { z } from "zod";

export const #$Schema = z.looseObject({
	#$
}).strip();

export type #$Schema = typeof #$Schema;

export namespace #$Schema {
	export type Type = z.infer<#$Schema>;
}
]],
			{
				i(1, "Name"),
				i(0),
				rep(1),
				rep(1),
				rep(1),
				rep(1),
			},
			{
				delimiters = "#$",
			}
		)
	),
	s(
		"fx",
		fmt(
			[[
import { Effect } from "effect";

export namespace #$Fx {
    export interface Props {
        #$
    }
}

export const #$Fx = Effect.fn("#$Fx")(function*({ 
    #$
}: #$Fx.Props) {
    #$
})

export type #$Fx = ReturnType<typeof #$Fx>;
        ]],
			{
				i(1, "Fx"),
				i(2, "props"),
				rep(1),
				rep(1),
				i(3, "props"),
				rep(1),
				i(0),
				rep(1),
				rep(1),
			},
			{
				delimiters = "#$",
			}
		)
	),
	s(
		"func",
		fmt(
			[[
export namespace #$ {
    export interface Props {
        #$
    }
}        

export const #$ = ({
    #$
}: #$.Props) => {
    return #$
}
        ]],
			{
				i(1, "Func"),
				i(2, "props"),
				rep(1),
				i(3, "props"),
				rep(1),
				i(0),
			},
			{
				delimiters = "#$",
			}
		)
	),
	s(
		"hook",
		fmt(
			[[
export namespace use#$ {
    export interface Props {
        #$
    }
}

export const use#$ = ({
    #$
}: use#$.Props) => {
    #$
}
        ]],
			{
				i(1, "Hook"),
				i(2, "props"),
				rep(1),
				i(3, "props"),
				rep(1),
				i(0),
			},
			{
				delimiters = "#$",
			}
		)
	),
}
