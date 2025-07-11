--色孽凰颜·福格瑞姆
function c21400072.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),aux.NonTuner(Card.IsSetCard,0x5210),1)
	c:EnableReviveLimit()
	--  
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(21400072,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,21400072+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c21400072.espcon)
	e1:SetTarget(c21400072.esptg)
	e1:SetOperation(c21400072.espop)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11400072)
	e2:SetTarget(c21400072.tgtg)
	e2:SetOperation(c21400072.tgop)
	c:RegisterEffect(e2)
end
function c21400072.espfilter(c,e,tp)
	return c:IsSetCard(0x5210) and c:IsLevelAbove(6)
		and Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())>0 and (c:IsControler(tp) or c:IsFaceup())
end
function c21400072.espcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,c21400072.espfilter,1,REASON_SPSUMMON,false,nil,e,tp)
end
function c21400072.esptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c21400072.espfilter,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c21400072.espop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON) 
end
function c21400072.tgfilter(c)
	return c:IsSetCard(0x5210) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c21400072.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400072.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c21400072.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c21400072.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end


