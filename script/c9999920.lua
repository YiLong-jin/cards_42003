--恶象天启 蓬莱寺九霄
function c9999920.initial_effect(c)

--  aux.AddXyzProcedure(c,c9999920.ovfilter1,nil,3,c9999920.ovfilter,aux.Stringid(9999920,0),1,c9999920.xyzop)
	c:EnableReviveLimit() 

	-- 特殊召唤手续
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c9999920.sprcon)
	e0:SetTarget(c9999920.sprtg)
	e0:SetOperation(c9999920.sprop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)

	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,9999920)
	e4:SetCondition(c9999920.spcon)
	e4:SetTarget(c9999920.settg)
	e4:SetOperation(c9999920.setop)
	c:RegisterEffect(e4)




	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9999921)
	e1:SetCost(c9999920.cost)
	e1:SetTarget(c9999920.sptg1)
	e1:SetOperation(c9999920.spop1)
	c:RegisterEffect(e1)




end
function c9999920.ovfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x669)
end

function c9999920.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x669) and c:IsLinkAbove(4)
end

function c9999920.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9999921)==0 end
	Duel.RegisterFlagEffect(tp,9999921,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end


-- 过滤：表侧表示的「逐火之蛾」怪兽
function c9999920.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x669)
end

-- 过滤：连接4以上的「逐火之蛾」怪兽
function c9999920.linkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x669) and c:IsLinkAbove(4)
end

-- 召唤条件检查
function c9999920.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, 0, nil)
	
	-- 常规方式：3只「逐火之蛾」怪兽
	if mg:FilterCount(c9999920.mfilter, nil) >= 3 then
		return true
	end
	
	-- 特殊方式：1只连接4以上的「逐火之蛾」怪兽，且本回合未使用过特殊方式
	if Duel.GetFlagEffect(tp, 9999921)==0 and mg:FilterCount(c9999920.linkfilter, nil) >= 1 then
		return true
	end
	
	return false
end

-- 选择素材
function c9999920.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	if chk==0 then return true end
	local mg=Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, 0, nil)
	local normal_avail = mg:FilterCount(c9999920.mfilter, nil) >= 3
	local special_avail = (Duel.GetFlagEffect(tp, 9999921)==0 and mg:FilterCount(c9999920.linkfilter, nil) >= 1)
	
	if normal_avail and special_avail then
		-- 两种方式均可，让玩家选择
		local op = Duel.SelectOption(tp, "使用3只「逐火之蛾」怪兽", "使用1只连接4以上的「逐火之蛾」怪兽")
		if op == 0 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
			local sg = mg:FilterSelect(tp, c9999920.mfilter, 3, 3, nil)
			sg:KeepAlive()
			e:SetLabelObject(sg)
			e:SetLabel(0)  -- 标记为常规方式
		else
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
			local sg = mg:FilterSelect(tp, c9999920.linkfilter, 1, 1, nil)
			sg:KeepAlive()
			e:SetLabelObject(sg)
			e:SetLabel(1)  -- 标记为特殊方式
		end
	elseif normal_avail then
		-- 只有常规方式
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
		local sg = mg:FilterSelect(tp, c9999920.mfilter, 3, 3, nil)
		sg:KeepAlive()
		e:SetLabelObject(sg)
		e:SetLabel(0)
	elseif special_avail then
		-- 只有特殊方式
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
		local sg = mg:FilterSelect(tp, c9999920.linkfilter, 1, 1, nil)
		sg:KeepAlive()
		e:SetLabelObject(sg)
		e:SetLabel(1)
	else
		return false  -- 理论上不会执行
	end
	return true
end

-- 召唤操作：叠放素材
function c9999920.sprop(e, tp, eg, ep, ev, re, r, rp, c)
	local g = e:GetLabelObject()
	c:SetMaterial(g)
	Duel.Overlay(c, g)
	g:DeleteGroup()
	
	-- 如果是特殊方式，设置一回合一次的限制标志
	if e:GetLabel() == 1 then
		Duel.RegisterFlagEffect(tp, 9999921, RESET_PHASE+PHASE_END, 0, 1)
	end
end


function c9999920.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9999920.setfilter(c)
	return c:IsSetCard(0x669) and c:IsType(TYPE_SPELL) and c:IsSSetable() and not c:IsType(TYPE_QUICKPLAY) and not c:IsType(TYPE_CONTINUOUS)
end
function c9999920.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9999920.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c9999920.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9999920.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		local c=e:GetHandler()
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(9999920,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	end
end

function c9999920.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c9999920.spfilter1(c,e,tp)
	return c:IsSetCard(0x669) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9999920.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9999920.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9999920.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9999920.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end


