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
    public partial class TPM_RewardBatchDal : BaseDal<TPM_RewardBatch>, ITPM_RewardBatchDal
    {
        public override DataTable GetListByPage(Hashtable ht, out int RowCount, bool IsPage = true, string Where = "")
        {
            RowCount = 0;
            List<SqlParameter> pms = new List<SqlParameter>();
            DataTable dt = new DataTable();
            try
            {
                StringBuilder str = new StringBuilder();
                str.Append(@" select r_bat.*,b.Name as CreateName,(select count(1) from TPM_RewardBatchDetail where IsDelete=0 and Status in(1,3) and RewardBatch_Id=r_bat.Id)UseCount
                  ,(select ISNULL(sum(Money),0) from TPM_RewardBatchDetail where IsDelete=0 and RewardBatch_Id=r_bat.Id)UseMoney  ");
                str.Append(@" from TPM_RewardBatch r_bat 
                                left join UserInfo b on r_bat.CreateUID=b.UniqueNo  where r_bat.IsDelete=0 ");
                int StartIndex = 0;
                int EndIndex = 0;
                if (ht.ContainsKey("Id") && !string.IsNullOrEmpty(ht["Id"].SafeToString()))
                {
                    str.Append(" and r_bat.Id=@Id ");
                    pms.Add(new SqlParameter("@Id", ht["Id"].ToString()));
                }
                if (ht.ContainsKey("Year") && !string.IsNullOrEmpty(ht["Year"].SafeToString()))
                {
                    str.Append(" and r_bat.Year like N'%' + @Year + '%'");
                    pms.Add(new SqlParameter("@Year", ht["Year"].ToString().Replace("年","")));
                }
                if (ht.ContainsKey("Name") && !string.IsNullOrEmpty(ht["Name"].SafeToString()))
                {
                    str.Append(" and r_bat.Name like N'%' + @Name + '%'");
                    pms.Add(new SqlParameter("@Name", ht["Name"].ToString()));
                }                
                if (ht.ContainsKey("IsMoneyAllot") && !string.IsNullOrEmpty(ht["IsMoneyAllot"].SafeToString()))
                {
                    str.Append(" and r_bat.IsMoneyAllot=@IsMoneyAllot ");
                    pms.Add(new SqlParameter("@IsMoneyAllot", ht["IsMoneyAllot"].ToString()));
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

        #region 获取奖金是否使用
        public int GetRewardMoney_UseCount(int RewardBatch_Id)
        {
            string str = "select count(1) from TPM_RewardBatchDetail where IsDelete=0 and Status in(1,3) and RewardBatch_Id=@RewardBatch_Id";
            List<SqlParameter> op_pms = new List<SqlParameter>();
            op_pms.Add(new SqlParameter("@RewardBatch_Id", RewardBatch_Id));
            int result =Convert.ToInt32(SQLHelp.ExecuteScalar(str, CommandType.Text, op_pms.ToArray()));
            return result;
        }
        #endregion

        #region 获取奖金批次分配金额
        public decimal GetRewardBatch_UseMoney(int RewardBatch_Id)
        {
            string str = "select ISNULL(sum(Money),0) from TPM_RewardBatchDetail where IsDelete=0 and RewardBatch_Id=@RewardBatch_Id";
            List<SqlParameter> op_pms = new List<SqlParameter>();
            op_pms.Add(new SqlParameter("@RewardBatch_Id", RewardBatch_Id));
            int result = Convert.ToInt32(SQLHelp.ExecuteScalar(str, CommandType.Text, op_pms.ToArray()));
            return result;
        }
        #endregion

        #region 根据关联Id删除信息
        public int DelRewBatchByRankId(int rank_Id)
        {
            string str = "update TPM_RewardBatch set IsDelete=1 where Rank_Id=@Rank_Id ";
            List<SqlParameter> op_pms = new List<SqlParameter>();
            op_pms.Add(new SqlParameter("@Rank_Id", rank_Id));           
            int result = SQLHelp.ExecuteNonQuery(str, CommandType.Text, op_pms.ToArray());
            return result;
        }
        #endregion    

        #region 删除奖金批次
        public int Del_RewardBatch(int itemid)
        {
            int result = 0;
            List<SqlParameter> pms = new List<SqlParameter>();
            StringBuilder str = new StringBuilder();
            str.Append("update TPM_RewardBatch set IsDelete=1 where Id=@Id;update TPM_RewardBatchDetail set IsDelete=1 where RewardBatch_Id=@Id ");
            pms.Add(new SqlParameter("@Id", itemid));
            result = SQLHelp.ExecuteNonQuery(str.ToString(), CommandType.Text, pms.ToArray());
            return result;
        }
        #endregion
    }
}
