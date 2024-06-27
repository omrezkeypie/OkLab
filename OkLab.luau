--!native
--!optimize 2
--!strict

local OkLab = {}

type OkLabColor = {
	L : number,
	A : number,
	B : number
}

local function CubeRoot(X : number) : number
	return X^(1/3)
end

local function Lerp(p0 : number, p1 : number, t : number): number
	return p0 + t * (p1 - p0)
end

function OkLab.FromRegularToLinear(Value: number): number
	if Value >= 0.04045 then
		return ((Value + 0.055)/(1.055))^2.4
	else
		return Value / 12.92
	end
end

function OkLab.FromLinearToRegular(Value: number): number
	if Value >= 0.0031308 then
		return (1.055) * Value ^ 0.5 - 0.055
	else
		return 12.92 * Value
	end
end 

function OkLab.sRGBToLab(Color: Color3): OkLabColor
	local R = OkLab.FromRegularToLinear(Color.R)
	local G = OkLab.FromRegularToLinear(Color.G)
	local B = OkLab.FromRegularToLinear(Color.B)

	local L = 0.4122214708 * R + 0.5363325363 * G + 0.0514459929 * B
	local M = 0.2119034982 * R + 0.6806995451 * G + 0.1073969566 * B
	local S = 0.0883024619 * R + 0.2817188376 * G + 0.6299787005 * B

	local L_ = CubeRoot(L)
	local M_ = CubeRoot(M)
	local S_ = CubeRoot(S)

	return {
		L = 0.2104542553 * L_ + 0.7936177850 * M_ - 0.0040720468 * S_,
		A = 1.9779984951 * L_ - 2.4285922050 * M_ + 0.4505937099 * S_,
		B = 0.0259040371 * L_ + 0.7827717662 * M_ - 0.8086757660 * S_
	}
end

function OkLab.LabTosRGB(OkLabColor: OkLabColor): Color3
	local L = OkLabColor.L
	local A = OkLabColor.A
	local B = OkLabColor.B

	local L_ = L + 0.3963377774 * A + 0.2158037573 * B
	local M_ = L - 0.1055613458 * A - 0.0638541728 * B
	local S_ = L - 0.0894841775 * A - 1.2914855480 * B

	local L = L_^3
	local M = M_^3
	local S = S_^3

	local R = OkLab.FromLinearToRegular( 4.0767416621 * L - 3.3077115913 * M + 0.2309699292 * S)
	local G = OkLab.FromLinearToRegular(-1.2684380046 * L + 2.6097574011 * M - 0.3413193965 * S)
	local B = OkLab.FromLinearToRegular(-0.0041960863 * L - 0.7034186147 * M + 1.7076147010 * S)

	return Color3.new(R, G, B)
end

function OkLab.LerpOkLabColors(OkLabColor1 : OkLabColor,OkLabColor2 : OkLabColor,T : number) : OkLabColor
	return {
		L = Lerp(OkLabColor1.L,OkLabColor2.L,T),
		A = Lerp(OkLabColor1.A,OkLabColor2.A,T),
		B = Lerp(OkLabColor1.B,OkLabColor2.B,T),
	}
end

return OkLab
