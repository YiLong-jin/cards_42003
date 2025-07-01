--公司安保
local m=71100001
local cm=_G["c"..m]
function cm.initial_effect(c)
	--sp1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon3)
	c:RegisterEffect(e1) 
	--Special Summon xyz
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,71100011)
	e4:SetCondition(cm.espcon)
	e4:SetTarget(cm.esptg)
	e4:SetOperation(cm.espop)
	c:RegisterEffect(e4) 
end
function cm.filters(c)
	return c:IsSetCard(0x7d0) and c:IsFaceup()
end
function cm.spcon3(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filters,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function cm.espcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSetCard,1,nil,0x7d0)  
end  
function cm.espfilter(c,e,tp,mc)
	local mc=e:GetHandler()
	return c:IsSetCard(0x7d0) and c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and mc:IsCanBeXyzMaterial(c) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end 
function cm.esptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.espfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,nil) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end 
function cm.espop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.IsExistingMatchingCard(cm.espfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,nil) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.espfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil):GetFirst() 
		if tc then
			local gx=Group.CreateGroup()
			Group.AddCard(gx,c)
			tc:SetMaterial(gx)
			Duel.Overlay(tc,gx)
			if Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
				tc:CompleteProcedure()
			end
		end
	end
end


