--「千年一叹」
local m=73116599
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
		e1:SetTarget(c73116599.target)
	e1:SetCondition(c73116599.spcon2)
	e1:SetOperation(c73116599.activate)
	c:RegisterEffect(e1)

end
function c73116599.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return aux.IsCanBeQuickEffect(e:GetHandler(),tp,73116550) and aux.IsCanBeQuickEffect(e:GetHandler(),tp,73116552) and aux.IsCanBeQuickEffect(e:GetHandler(),tp,73116554) and aux.IsCanBeQuickEffect(e:GetHandler(),tp,73116556) and aux.IsCanBeQuickEffect(e:GetHandler(),tp,73116558) and aux.IsCanBeQuickEffect(e:GetHandler(),tp,73116560) and aux.IsCanBeQuickEffect(e:GetHandler(),tp,73116562) 
end
function c73116599.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(73116550,0))
	Duel.Hint(24,0,aux.Stringid(73116552,0))
		Duel.Hint(24,0,aux.Stringid(73116554,0))
			Duel.Hint(24,0,aux.Stringid(73116556,0))
				Duel.Hint(24,0,aux.Stringid(73116558,0))
					Duel.Hint(24,0,aux.Stringid(73116560,0))
						Duel.Hint(24,0,aux.Stringid(73116562,0))
	local WIN_REASON_CELESTIAL_WHIRLPOOL=0x99aa
	Duel.Win(tp,WIN_REASON_CELESTIAL_WHIRLPOOL)
end
function c73116599.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c73116599.chainlm)
	end
end
function c73116599.chainlm(e,ep,tp)
	return tp==ep
end
