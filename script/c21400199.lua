--亡灵海岸-洋流猎杀队
function c21400199.initial_effect(c) 
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA) 
	e1:SetCondition(c21400199.hspcon)
	e1:SetTarget(c21400199.hsptg)
	e1:SetOperation(c21400199.hspop)
	c:RegisterEffect(e1)   
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21400199,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,21400199)
	e1:SetTarget(c21400199.thtg)
	e1:SetOperation(c21400199.thop)
	c:RegisterEffect(e1)
end
function c21400199.matfil(c,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3211) and c:IsAbleToGraveAsCost()
end
function c21400199.xmatfil(c) 
	return c:IsSetCard(0x3211) and c:IsLevelAbove(5)  
end 
function c21400199.matgck(g,e,tp) 
	return g:FilterCount(c21400199.xmatfil,nil)>=1 and Duel.GetLocationCountFromEx(tp,tp,g,e:GetHandler())>0 
end 
function c21400199.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c21400199.matfil,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,tp)
	return g:CheckSubGroup(c21400199.matgck,2,2,e,tp)
end
function c21400199.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c21400199.matfil,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c21400199.matgck,true,2,2,e,tp)
	if sg~=nil and sg:GetCount()>0 then 
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c21400199.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
end
function c21400199.thfilter(c)
	return c:IsSetCard(0x3211) and c:IsAbleToHand()
end
function c21400199.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400199.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21400199.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400199.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


