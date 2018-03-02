using FEDAL;
using FEIBLL;
using FEModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEBLL
{
    public partial class TPM_RewardInfoService : BaseService<TPM_RewardInfo>, ITPM_RewardInfoService
    {
        TPM_RewardInfoDal dal = new TPM_RewardInfoDal();
        TPM_RewardBatchDal bat_dal = new TPM_RewardBatchDal();
        TPM_RewardBatchDetailDal batdetail_dal = new TPM_RewardBatchDetailDal();
        #region 调整业绩等级顺序
        public JsonModel TPM_RewardInfoSort(int id, string SortType)
        {
            JsonModel jsonModel = new JsonModel();
            try
            {
                string result = dal.TPM_RewardInfoSort(id, SortType);
                if (result == "")
                {
                    jsonModel = new JsonModel()
                    {
                        errNum = 0,
                        errMsg = "",
                        retData = ""
                    };
                }
                else
                {
                    jsonModel = new JsonModel()
                    {
                        errNum = 999,
                        errMsg = result,
                        retData = ""
                    };
                }
                return jsonModel;
            }
            catch (Exception ex)
            {
                jsonModel = new JsonModel()
                {
                    errNum = 400,
                    errMsg = ex.Message,
                    retData = ""
                };
                return jsonModel;
            }
        }

        #endregion

        #region 获取奖项是否使用
        public int GetReward_UseCount(int Reward_Id)
        {
            return dal.GetReward_UseCount(Reward_Id);
        }
        #endregion

        #region 获取奖项分数是否使用
        public int GetRewardScore_UseCount(int Reward_Id)
        {
            return dal.GetRewardScore_UseCount(Reward_Id);
        }
        #endregion

        #region 获取奖金批次是否使用
        public int GetRewardMoney_UseCount(int RewardBatch_Id)
        {
            return bat_dal.GetRewardMoney_UseCount(RewardBatch_Id);
        }
        #endregion 

        #region 获取奖金批次分配金额
        public decimal GetRewardBatch_UseMoney(int RewardBatch_Id)
        {
            return bat_dal.GetRewardBatch_UseMoney(RewardBatch_Id);
        }
        #endregion

        #region 删除奖金批次
        public JsonModel Del_RewardBatch(int itemid)
        {
            JsonModel jsonModel = new JsonModel();
            try
            {
                int result = bat_dal.Del_RewardBatch(itemid);
                if (result > 0)
                {
                    jsonModel = new JsonModel()
                    {
                        errNum = 0,
                        errMsg = "success",
                        retData = ""
                    };
                }
                else
                {
                    jsonModel = new JsonModel()
                    {
                        errNum = 999,
                        errMsg = "file",
                        retData = ""
                    };
                }
                return jsonModel;
            }
            catch (Exception ex)
            {
                jsonModel = new JsonModel()
                {
                    errNum = 400,
                    errMsg = ex.Message,
                    retData = ""
                };
                return jsonModel;
            }
        }
        #endregion    

        #region 添加奖金批次详情
        public JsonModel Add_RewardBatchDetail(int batchid,string achieve_Ids,string createUID)
        {
            JsonModel jsonModel = new JsonModel();
            try
            {
                int result = batdetail_dal.Add_RewardBatchDetail(batchid, achieve_Ids,createUID);
                if (result > 0)
                {
                    jsonModel = new JsonModel()
                    {
                        errNum = 0,
                        errMsg = "success",
                        retData = ""
                    };
                }
                else
                {
                    jsonModel = new JsonModel()
                    {
                        errNum = 999,
                        errMsg = "file",
                        retData = ""
                    };
                }
                return jsonModel;
            }
            catch (Exception ex)
            {
                jsonModel = new JsonModel()
                {
                    errNum = 400,
                    errMsg = ex.Message,
                    retData = ""
                };
                return jsonModel;
            }
        }
        #endregion    
    }
}
