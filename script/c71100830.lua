--宇宙之渴望驾驭 2025/11/06 15:35:12 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	-- 同调召唤条件
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_FIEND),1)
	
	-- ①效果：同调召唤时里侧除外
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(this.rmcon)
	e1:SetTarget(this.rmtg)
	e1:SetOperation(this.rmop)
	c:RegisterEffect(e1)
	
	-- ②效果：回复LP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(this.rectg)
	e2:SetOperation(this.recop)
	c:RegisterEffect(e2)
	
	-- ③效果：回卡组+伤害转移
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(this.tdcon)
	e3:SetTarget(this.tdtg)
	e3:SetOperation(this.tdop)
	c:RegisterEffect(e3)
end

-- ①效果：同调召唤成功时
function this.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function this.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,6,tp,LOCATION_DECK)
end
function this.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,6)
	if #g==6 then
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end

-- ②效果：回复LP
function this.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if chk==0 then return ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*100)
end
function this.recop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if ct>0 then
		Duel.Recover(tp,ct*100,REASON_EFFECT)
	end
end

-- ③效果：回卡组+伤害转移
function this.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function this.tdfilter(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function this.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(this.tdfilter,tp,LOCATION_REMOVED,0,9,9,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,this.tdfilter,tp,LOCATION_REMOVED,0,9,9,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,9,0,0)
end
function this.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg~=9 then return end
	
	if Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		-- 伤害转移效果
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(this.reftg)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function this.reftg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x67a3)
end
