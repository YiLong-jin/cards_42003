--爵银卿 吸血鬼
local cm,m,offset=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,9,3,nil,nil,99)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.lvtg)
	e1:SetValue(cm.lvval)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.TRUE)
	e2:SetCondition(cm.etcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.etcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--gain control
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(cm.dacost)
	e4:SetOperation(cm.daop)
	c:RegisterEffect(e4)
	--discard deck
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(cm.distg)
	e5:SetOperation(cm.disop)
	c:RegisterEffect(e5)
end
function cm.lvtg(e,c)
	return c:IsSetCard(0x8e) or c:GetOwner()~=e:GetHandlerPlayer()
end
function cm.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 9
	else return lv end
end
function cm.etcon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function cm.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.contf(c,e)
	return c:IsControlerCanBeChanged() and not c:IsImmuneToEffect(e)
end
function cm.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,1-tp,LOCATION_REASON_CONTROL)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(cm.contf,nil,e)
	if #g>ft then g=g:Select(tp,ft,ft,nil) end 
	Duel.GetControl(g,tp,PHASE_BATTLE,1)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,0,LOCATION_DECK,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,1,1-tp,1)
end
function cm.cfilter(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,0,LOCATION_DECK,nil)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=g:Select(tp,1,1,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT)==0 then return end
	local tc=g:GetFirst()
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(73082255,1)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
