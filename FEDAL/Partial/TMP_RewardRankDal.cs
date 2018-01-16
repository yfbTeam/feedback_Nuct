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
    public partial class TMP_RewardRankDal : BaseDal<TMP_RewardRank>, ITMP_RewardRankDal
    {
        public override DataTable GetListByPage(Hashtable ht, out int RowCount, bool IsPage = true, string Where = "")
        {
            RowCount = 0;
            List<SqlParameter> pms = new List<SqlParameter>();
            DataTable dt = new DataTable();
            try
            {
                StringBuilder str = new StringBuilder();
                if (ht["IsAward"].SafeToString() == "1")
                {
                    str.Append(@"select *,(select Money from TPM_RewardBatch where Id=trank.FirstId) as FirstMoney,
                isnull((select STUFF((select '+' + CAST(Money AS NVARCHAR(MAX)) from TPM_RewardBatch where IsDelete=0 and Reward_Id=trank.RId and Rank_Id=trank.Id and Id!=trank.FirstId FOR xml path('')), 1, 1, '')),0) as AddMoney
                from
                (select *,(select top 1 Id from TPM_RewardBatch where Reward_Id=info.RId and Rank_Id=info.Id and IsDelete=0 order by Id) as FirstId
                 from TMP_RewardRank info) as trank where trank.IsDelete=0 ");
                }else
                {
                    str.Append(@" select trank.*
                 ,(select count(1) from TPM_AcheiveRewardInfo where IsDelete=0 and sort=trank.Id) as UseCount 
                 from TMP_RewardRank trank where trank.IsDelete=0  ");
                }               
                int StartIndex = 0;
                int EndIndex = 0;
                if (ht.ContainsKey("RId") && !string.IsNullOrEmpty(ht["RId"].SafeToString()))
                {
                    str.Append(" and trank.RId=@RId ");
                    pms.Add(new SqlParameter("@RId", ht["RId"].ToString()));
                }               
                if (ht.ContainsKey("Id") && !string.IsNullOrEmpty(ht["Id"].SafeToString()))
                {
                    str.Append(" and trank.Id=@Id ");
                    pms.Add(new SqlParameter("@Id", ht["Id"].ToString()));
                }                
                if (IsPage)
                {
                    StartIndex = Convert.ToInt32(ht["StartIndex"].ToString());
                    EndIndex = Convert.ToInt32(ht["EndIndex"].ToString());
                }
                dt = SQLHelp.GetListByPage("(" + str.ToString() + ")", Where, "RankNum desc", StartIndex, EndIndex, IsPage, pms.ToArray(), out RowCount);
            }
            catch (Exception ex)
            {
                LogService.WriteErrorLog(ex.Message);
            }
            return dt;
        }

        #region 生成排序        
        public string GenerateRank(string RId, string RankNum, string HighScore, string OneRank, string OneScore, string TwoRank, string TwoScore, string CreateUID)
        {
            SqlParameter[] param = {
                    new SqlParameter("@RId", RId),
                    new SqlParameter("@RankNum",RankNum),
                    new SqlParameter("@HighScore", HighScore),
                    new SqlParameter("@OneRank",OneRank),
                    new SqlParameter("@OneScore", OneScore),
                    new SqlParameter("@TwoRank",TwoRank),
                    new SqlParameter("@TwoScore", TwoScore),
                    new SqlParameter("@CreateUID",CreateUID)
            };
            object obj = SQLHelp.ExecuteScalar("TPM_GenerateRank", CommandType.StoredProcedure, param);
            return obj.ToString();
        }
        #endregion

        #region 修改等级排名
        public int Edit_Rank(List<TMP_RewardRank> items)
        {
            string str = "";
            List<SqlParameter> pms = new List<SqlParameter>();
            for (int i=0;i< items.Count; i++)
            {
                TMP_RewardRank item = items[i];
                str += "update TMP_RewardRank set Score=@Score"+i+" where Id=@Id"+i+";";
                pms.Add(new SqlParameter("@Id"+i, item.Id));
                pms.Add(new SqlParameter("@Score"+i, item.Score));
            }           
            return SQLHelp.ExecuteNonQuery(str, CommandType.Text, pms.ToArray());
        }
        #endregion
    }
}
