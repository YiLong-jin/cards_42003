--针的魔女
local cm,m=GetID()
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c42624999") end) then require("script/c42624999") end

cm.Majo=true
mR.MajoID[m]=101
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,5,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,0x14,0,Duel.Remove,POS_FACEUP,REASON_COST+REASON_MATERIAL):SetValue(SUMMON_TYPE_FUSION)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCTCRPC(nil,"etqo",EVENT_FREE_CHAIN,0x04,nil,1)
	e3:SetCCTO(nil,nil,cm.catg,cm.caop)
	c:RegisterEffect(e3)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(0x04)
	e6:SetTargetRange(0,0x04)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE))
	e6:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e6)
	--cannot attack
	local e4=e6:Clone()
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e4)
end

function cm.ffilter(c,fc,sub,mg,sg)
	return c.Majo and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end

function cm.catg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(mR.FaceupFilter(aux.NOT(Card.IsAttribute)),tp,0,0x04,1,nil,ATTRIBUTE_FIRE) end
end

function cm.caop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectMatchingCard(tp,mR.FaceupFilter(aux.NOT(Card.IsAttribute)),tp,0,0x04,1,1,nil,ATTRIBUTE_FIRE):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		if not tc:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetValue(ATTRIBUTE_FIRE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end