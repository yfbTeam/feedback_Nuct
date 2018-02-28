using FEIDAL;
using FEModel;
using FEUtility;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEDAL
{
    public partial class TPM_RewardBatchDetailDal : BaseDal<TPM_RewardBatchDetail>, ITPM_RewardBatchDetailDal
    {
        public override DataTable GetListByPage(Hashtable ht, out int RowCount, bool IsPage = true, string Where = "")
        {
            RowCount = 0;
            List<SqlParameter> pms = new List<SqlParameter>();
            DataTable dt = new DataTable();
            try
            {
                StringBuilder str = new StringBuilder();
                str.Append(@" select r_bat.*,b.Name as CreateName,(select count(1) from TPM_RewardBatchDetail where IsDelete=0 and Status in(1,3) and RewardBatch_Id=r_bat.Id)UseCount ");
                if (ht["IsOnlyBase"].SafeToString() == "1") //查询关联表
                {
                    str.Append(@" ,info.Id AchieveId,isnull(aud.Id,0) AuditId,isnull(aud.Status,10)AuditStatus 
                      ,isnull((select sum(AllotMoney) from TPM_AllotReward where BatchDetail_Id=aud.Id),0)HasAllot
                     from TPM_RewardBatch r_bat
                     left join UserInfo b on r_bat.CreateUID=b.UniqueNo
                     left join TPM_AcheiveRewardInfo info on r_bat.Reward_Id=info.Rid and isnull(info.Sort,0)=isnull(r_bat.Rank_Id,0) and info.IsDelete=0
                     left join TPM_RewardBatchDetail aud on r_bat.Id=aud.RewardBatch_Id and info.Id=aud.Acheive_Id and aud.IsDelete=0 ");
                }
                else //只查询基础表
                {
                    str.Append(@" from TPM_RewardBatch r_bat 
                                left join UserInfo b on r_bat.CreateUID=b.UniqueNo ");
                }
                str.Append(@" where r_bat.IsDelete=0 ");
                int StartIndex = 0;
                int EndIndex = 0;
                if (ht.ContainsKey("RewardBatch_Id") && !string.IsNullOrEmpty(ht["RewardBatch_Id"].SafeToString()))
                {
                    str.Append(" and r_bat.RewardBatch_Id=@RewardBatch_Id ");
                    pms.Add(new SqlParameter("@RewardBatch_Id", ht["RewardBatch_Id"].ToString()));
                }
                if (ht.ContainsKey("Rank_Id") && !string.IsNullOrEmpty(ht["Rank_Id"].SafeToString()))
                {
                    str.Append(" and r_bat.Rank_Id=@Rank_Id ");
                    pms.Add(new SqlParameter("@Rank_Id", ht["Rank_Id"].ToString()));
                }
                if (ht.ContainsKey("AchieveId") && !string.IsNullOrEmpty(ht["AchieveId"].SafeToString()))
                {
                    str.Append(" and info.Id=@AchieveId ");
                    pms.Add(new SqlParameter("@AchieveId", ht["AchieveId"].ToString()));
                }
                if (ht.ContainsKey("Id") && !string.IsNullOrEmpty(ht["Id"].SafeToString()))
                {
                    str.Append(" and r_bat.Id=@Id ");
                    pms.Add(new SqlParameter("@Id", ht["Id"].ToString()));
                }
                if (ht.ContainsKey("AuditStatus") && !string.IsNullOrEmpty(ht["AuditStatus"].SafeToString()))
                {
                    str.Append(" and isnull(aud.Status,10) " + ht["AuditStatus"].ToString());
                }
                if (IsPage)
                {
                    StartIndex = Convert.ToInt32(ht["StartIndex"].ToString());
                    EndIndex = Convert.ToInt32(ht["EndIndex"].ToString());
                }
                string orderby = "Id";
                dt = SQLHelp.GetListByPage("(" + str.ToString() + ")", Where, orderby, StartIndex, EndIndex, IsPage, pms.ToArray(), out RowCount);
            }
            catch (Exception ex)
            {
                LogService.WriteErrorLog(ex.Message);
            }
            return dt;
        }
    }
}
