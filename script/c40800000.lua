--芝士 绯
function c40800000.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c40800000.ff,2,true)
end
c40800000.SetCard_RR_ZS=true 
function c40800000.ff(c) 
	return c.SetCard_RR_ZS 
end