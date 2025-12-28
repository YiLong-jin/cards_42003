--阴阳祖师·久苑


local s,id,o=GetID()
function s.initial_effect(c)
	-- 融合怪兽设定
	c:EnableReviveLimit()
	
	-- 融合条件：超凡世界怪兽×5
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x67f),4,true)
	
	-- 效果①：特殊召唤衍生物
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,99971056)
	e2:SetTarget(s.tktg)
	e2:SetOperation(s.tkop)
	c:RegisterEffect(e2)
	
	-- 效果②：提升通常怪兽攻击力
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,99971059)
	e3:SetCondition(s.atkcon)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
	
		-- 提升攻击力效果
   	 	local e13=Effect.CreateEffect(c)
		e13:SetType(EFFECT_TYPE_FIELD)
		e13:SetRange(LOCATION_MZONE)
		e13:SetCode(EFFECT_UPDATE_ATTACK)
			e13:SetTargetRange(LOCATION_MZONE,0)
		e13:SetCondition(s.atkcon1)
		e13:SetValue(2000)
		c:RegisterEffect(e13)
end



-- 效果①：特殊召唤衍生物
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,0)
end

function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	-- 特殊召唤小纸人衍生物
	local token1=Duel.CreateToken(tp,99971051)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetOperation(s.drawop)
		token1:RegisterEffect(e1,true)
	Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)

	
	-- 特殊召唤暴鬼衍生物
	local token2=Duel.CreateToken(tp,99971052)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetOperation(s.drawop)
		token2:RegisterEffect(e2,true)
		Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP)

	
	-- 特殊召唤天后衍生物
		local token3=Duel.CreateToken(tp,99971053)
			-- 衍生物效果：离场增幅
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetOperation(s.drawop)
		token3:RegisterEffect(e3,true)
		Duel.SpecialSummonStep(token3,0,tp,tp,false,false,POS_FACEUP)

	
	Duel.SpecialSummonComplete()
end
function c99971050.filter(c)
	return c:GetFlagEffect(1082946)~=0 and (c:IsSetCard(0x67f) or c:IsCode(99971050))
end
function c99971050.filter1(c,code)
	return c:GetFlagEffect(1082946)~=0 and c:IsCode(code)
end
-- 衍生物离场增幅
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c99971050.filter,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	local code=tc:GetCode()
	local flag=3
	while flag>0 do
		if Duel.IsExistingMatchingCard(c99971050.filter1,tp,0x3f,0x3f,1,nil,code) then 
			op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
			flag=flag-1
		else
			flag=0
		end
	end
end


function s.atkcon(e)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,99971050)==0 
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	-- 无立即操作，只是设置状态
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971050,4))
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,99971050)~=0 then return end
	Duel.RegisterFlagEffect(tp,99971050,RESET_PHASE+PHASE_END,0,10)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c99971050.checkop)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END,10)
	Duel.RegisterEffect(e1,tp)
	e1:SetLabelObject(e1)
	c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,10)
	c99971050[c]=e1
   
end
function c99971050.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,99971050)
	c:SetHint(CHINT_TURN,ct)
	Duel.RegisterFlagEffect(tp,99971050,RESET_PHASE+PHASE_END,0,11-ct)
	if ct>=10 then
	-- 第15回合时赋予效果
		Duel.Hint(HINT_CARD,1-tp,id)
		c:ResetFlagEffect(1082946)
		c:ResetFlagEffect(99971050)
		Duel.ResetFlagEffect(tp,1082946)
		Duel.ResetFlagEffect(tp,99971050)
	-- 提升攻击力效果
		Duel.RegisterFlagEffect(tp,99971059,nil,0,98)
		e:GetHandler():RegisterFlagEffect(0,RESET_EVENT,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971050,5))
		e:GetLabelObject():Reset()
	end
end
function s.tokenfilter(c)
	return c:IsCode(99971051,99971052,99971053)
end

-- 自身攻击力提升条件：检查场上有衍生物
function s.atkcon1(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(s.tokenfilter,c:GetControler(),LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,99971059)~=0
end

 