--凶星坠落的灵峰 2024/09/05 13:19:18 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(this.thtg)
	e3:SetOperation(this.thop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,id+ofs)
	e4:SetCondition(this.damcon)
	e4:SetTarget(this.damtg)
	e4:SetOperation(this.damop)
	c:RegisterEffect(e4)
end
local thloc = LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED
function this.sfilter(c)
	return c:IsSetCard(0x7d5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsFaceupEx()
end
function this.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(this.sfilter,tp,thloc,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,thloc)
end
function this.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,this.sfilter,tp,thloc,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function this.damfilter(c,tp,e)
	if c:IsRace(RACE_DRAGON) and c:IsType(TYPE_LINK) then return true end
	local rc=c:GetBattleTarget()
	return rc:IsRace(RACE_DRAGON) and rc:IsType(TYPE_LINK)
		and (not rc:IsLocation(LOCATION_MZONE) and rc:IsPreviousControler(tp)
			or rc:IsLocation(LOCATION_MZONE) and rc:IsControler(tp))
end
function this.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(this.damfilter,1,nil,tp,e)
end
function this.tgfilter(c,e)
	return not c:IsType(TYPE_TOKEN) and c:IsFaceupEx() and c:GetBaseAttack()>0 and c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e)
end
function this.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=eg:Filter(this.tgfilter,nil,e)
	if chk==0 then return g:GetCount()>0 end
	local bc=g:GetFirst()
	if g:GetCount()>1 then
		bc=g:FilterSelect(tp,this.tgfilter,1,1,nil,e):GetFirst()
	end
	Duel.SetTargetCard(bc)
	local dam=bc:GetBaseAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function this.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)
	end
end
