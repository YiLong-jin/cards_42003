--渴血的光 2025/12/07 22:56:13 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	--act
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(this.destg)
	e1:SetOperation(this.desop)
	c:RegisterEffect(e1)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id+ofs)
	e3:SetCondition(this.setcon)
	e3:SetTarget(this.settg)
	e3:SetOperation(this.setop)
	c:RegisterEffect(e3)
end
function this.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function this.des_monster_filter(c,e,tp)
	return c:IsDestructable(e) and Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(this.spf),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp)
end 
function this.spf(c,e,tp)
	return c:IsSetCard(0xc7a3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end 
function this.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(g,REASON_EFFECT)<1 and Duel.IsExistingMatchingCard(this.des_monster_filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,this.des_monster_filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		if #dg>0 and Duel.Destroy(dg,REASON_EFFECT)~=0 then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(this.spf),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
			if #sg>0 then 
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end 
		end
	end
end
function this.setfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(1-tp) and c:GetReasonPlayer()==tp
end
function this.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(this.setfilter,1,nil,tp)
end
function this.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function this.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and aux.NecroValleyFilter()(c) then 
		Duel.SSet(tp,c)
	end
end
