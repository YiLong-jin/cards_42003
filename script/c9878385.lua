--黑江 夏日风情
local cm,m=GetID()
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c42624999") end) then require("script/c42624999") end

cm.Magia_Summer_Vacation=true
function cm.initial_effect(c)
	aux.AddCodeList(c,9877873,9877918,42624036)
	aux.AddFusionProcCodeFun(c,9877918,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),1,true,true)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCTCRPC(CATEGORY_SPECIAL_SUMMON,"etto+s",EVENT_SPSUMMON_SUCCESS,nil,0x10000,1,m)
	e1:SetCCTO(cm.spcon,nil,cm.sptg,cm.spop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCTCRPC(nil,"etto+f",EVENT_PHASE+PHASE_END,0x04,nil,1,m)
	e3:SetCCTO(nil,nil,cm.setg,cm.seop)
	c:RegisterEffect(e3)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(0x04)
	e2:SetTargetRange(0x04,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SPELLCASTER))
	e2:SetValue(200)
	c:RegisterEffect(e2)
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

function cm.tgsfilter(c,e,tp)
	return c:IsFaceup() and (c.Magia_Summer_Vacation or c:IsCodeListed(9877918)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x30,0,1,nil,e,tp) and aux.mzctcheck(nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x30)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if aux.mzctcheck(nil,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.tgsfilter,tp,0x30,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function cm.tgsefilter(c)
	return (c:IsCode(42624036) or c:IsCodeListed(9877873)) and c:IsSSetable() and c:IsType(0x4) and c:IsFaceup()
end

function cm.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgsefilter,tp,0x30,0,1,nil) end
end

function cm.seop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.tgsefilter,tp,0x30,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end