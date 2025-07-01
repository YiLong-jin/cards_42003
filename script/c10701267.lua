--变形斗士·传真机
function c10701267.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10701267.spcon)
	e1:SetOperation(c10701267.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1) 
	--speical summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701267,0))
	e2:SetCategory(CATEGORY_DICE+CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c10701267.cona)
	e2:SetTarget(c10701267.tga)
	e2:SetOperation(c10701267.opa)
	c:RegisterEffect(e2)	  
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701267,3))
	e3:SetCategory(CATEGORY_DICE+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c10701267.cond)
	e3:SetTarget(c10701267.tgd)
	e3:SetOperation(c10701267.opd)
	c:RegisterEffect(e3)
end
c10701267.toss_dice=true
function c10701267.spfilter(c,ft)
	return c:IsFaceup() and c:IsSetCard(0x26) and c:IsAbleToRemoveAsCost() and (ft>0 or c:GetSequence()<5)
end
function c10701267.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c10701267.spfilter,tp,LOCATION_MZONE,0,1,nil,ft)
end
function c10701267.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10701267.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10701267.cona(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackPos()
end
function c10701267.tga(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c10701267.spfilter2(c,e,tp,dc)
	return c:IsSetCard(0x26) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(dc)
end
function c10701267.opa(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.TossDice(tp,1)
	local rec=dc*100
	local g=Duel.GetMatchingGroup(c10701267.spfilter2,tp,LOCATION_REMOVED,0,nil,e,tp,dc)
	if Duel.Recover(tp,rec,REASON_EFFECT)>0 and g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(10701267,5)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10701267.cond(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsDefensePos()
end
function c10701267.tgd(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c10701267.opd(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local dc=Duel.TossDice(tp,1)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10701267,4))
	e:SetLabel(Duel.AnnounceLevel(tp,1,dc,lv))
	local ct=e:GetLabel()
	local sel=nil
	if c:IsLevel(1) then
		sel=Duel.SelectOption(tp,aux.Stringid(10701267,1))
	else
		sel=Duel.SelectOption(tp,aux.Stringid(10701267,1),aux.Stringid(10701267,2))
	end
	if sel==1 then
		ct=ct*-1
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(ct)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end