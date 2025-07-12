--秘源学者 拉比
function c71100301.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to grave and set  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71100301,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,71100301)
	e1:SetTarget(c71100301.tgstg)
	e1:SetOperation(c71100301.tgsop)
	c:RegisterEffect(e1)
end
function c71100301.tgfil(c,e,tp)
	return c:IsSetCard(0x37de) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c71100301.stfil,tp,LOCATION_DECK,0,1,nil)
end
function c71100301.stfil(c) 
	return c:IsSetCard(0x57de) and c:IsSSetable() 
end 
function c71100301.tgstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71100301.tgfil,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c71100301.tgsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c71100301.tgfil,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c71100301.stfil,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 then 
	local dg=g1:Select(tp,1,1,nil)
	Duel.SendtoGrave(dg,REASON_EFFECT) 
	if g2:GetCount()>0 then 
	local tc=g2:Select(tp,1,1,nil) 
	Duel.SSet(tp,tc) 
	end 
	end
end



