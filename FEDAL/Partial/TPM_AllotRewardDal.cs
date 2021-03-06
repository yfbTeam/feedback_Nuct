﻿using FEIDAL;
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
    public partial class TPM_AllotRewardDal : BaseDal<TPM_AllotReward>, ITPM_AllotRewardDal
    {
        public override DataTable GetListByPage(Hashtable ht, out int RowCount, bool IsPage = true, string Where = "")
        {
            RowCount = 0;
            List<SqlParameter> pms = new List<SqlParameter>();
            DataTable dt = new DataTable();
            try
            {
                StringBuilder str = new StringBuilder();
                str.Append(@" select allot.*,aud.Acheive_Id,aud.RewardBatch_Id,aud.Status
                       ,ba.Year as BatYear,ba.Name as BatName
                     from TPM_AllotReward allot
                     left join TPM_RewardBatchDetail aud on allot.BatchDetail_Id=aud.Id
                     left join TPM_RewardBatch ba on aud.RewardBatch_Id=ba.Id
                     where allot.IsDelete=0 ");               
                int StartIndex = 0;
                int EndIndex = 0;
                if (ht.ContainsKey("RewardBatch_Id") && !string.IsNullOrEmpty(ht["RewardBatch_Id"].SafeToString()))
                {
                    str.Append(" and aud.RewardBatch_Id=@RewardBatch_Id ");
                    pms.Add(new SqlParameter("@RewardBatch_Id", ht["RewardBatch_Id"].ToString()));
                }
                if (ht.ContainsKey("BatchDetail_Id") && !string.IsNullOrEmpty(ht["BatchDetail_Id"].SafeToString()))
                {
                    str.Append(" and allot.BatchDetail_Id=@BatchDetail_Id ");
                    pms.Add(new SqlParameter("@BatchDetail_Id", ht["BatchDetail_Id"].ToString()));
                }
                if (ht.ContainsKey("Acheive_Id") && !string.IsNullOrEmpty(ht["Acheive_Id"].SafeToString()))
                {
                    str.Append(" and aud.Acheive_Id=@Acheive_Id ");
                    pms.Add(new SqlParameter("@Acheive_Id", ht["Acheive_Id"].ToString()));
                }
                if (ht.ContainsKey("Id") && !string.IsNullOrEmpty(ht["Id"].SafeToString()))
                {
                    str.Append(" and allot.Id=@Id ");
                    pms.Add(new SqlParameter("@Id", ht["Id"].ToString()));
                }
                if (ht.ContainsKey("No_Status") && !string.IsNullOrEmpty(ht["No_Status"].SafeToString()))
                {
                    str.Append(" and aud.Status!=@No_Status");
                    pms.Add(new SqlParameter("@No_Status", ht["No_Status"].ToString()));
                }                
                if (IsPage)
                {
                    StartIndex = Convert.ToInt32(ht["StartIndex"].ToString());
                    EndIndex = Convert.ToInt32(ht["EndIndex"].ToString());
                }
                dt = SQLHelp.GetListByPage("(" + str.ToString() + ")", Where, "", StartIndex, EndIndex, IsPage, pms.ToArray(), out RowCount);
            }
            catch (Exception ex)
            {
                LogService.WriteErrorLog(ex.Message);
            }
            return dt;
        }

        #region 保存奖金分配信息
        public int Oper_AuditAllotReward(TPM_RewardBatchDetail audModel, List<TPM_AllotReward> items)
        {
            int result = 0;
            List<SqlParameter> pms = new List<SqlParameter>();
            StringBuilder str = new StringBuilder();      
            pms.Add(new SqlParameter("@BatchDetail_Id", audModel.Id));
            if (items.Count() > 0)
            {
                for (int i = 0; i < items.Count; i++)
                {
                    TPM_AllotReward item = items[i];                    
                    if (item.AllotMoney == null)
                    {
                        pms.Add(new SqlParameter("@AllotMoney" + i, DBNull.Value));
                    }
                    else
                    {
                        pms.Add(new SqlParameter("@AllotMoney" + i, item.AllotMoney));
                    }
                    pms.Add(new SqlParameter("@RewardUser_Id" + i, item.RewardUser_Id));
                    pms.Add(new SqlParameter("@CreateUID" + i, item.CreateUID));
                    pms.Add(new SqlParameter("@EditUID" + i, item.CreateUID));
                    string allotsql = "select Id from TPM_AllotReward where BatchDetail_Id=@BatchDetail_Id and RewardUser_Id=@RewardUser_Id" + i + " and IsDelete=0";
                    int allotid = Convert.ToInt32(SQLHelp.ExecuteScalar(allotsql, CommandType.Text, pms.ToArray()));
                    if (allotid > 0)
                    {
                        pms.Add(new SqlParameter("@Id" + i, allotid));
                        str.Append("update TPM_AllotReward set AllotMoney=@AllotMoney" + i + ",EditUID=@EditUID" + i + " where Id=@Id" + i + ";");
                    }
                    else
                    {
                        str.Append(@"insert into TPM_AllotReward(BatchDetail_Id,AllotMoney,RewardUser_Id,CreateUID) 
                            values(@BatchDetail_Id,@AllotMoney" + i + ",@RewardUser_Id" + i + ",@CreateUID" + i + ");");
                    }
                }
                result = SQLHelp.ExecuteNonQuery(str.ToString(), CommandType.Text, pms.ToArray());
            }
            return result;
        }
        #endregion

        #region 管理员修改审核通过的奖金分配信息
        public int Admin_EditAllotReward(List<TPM_AllotReward> items)
        {
            int result = 0;
            List<SqlParameter> pms = new List<SqlParameter>();
            StringBuilder str = new StringBuilder();           
            if (items.Count() > 0)
            {
                for (int i = 0; i < items.Count; i++)
                {
                    TPM_AllotReward item = items[i];
                    if (item.AllotMoney == null)
                    {
                        pms.Add(new SqlParameter("@AllotMoney" + i, DBNull.Value));
                    }
                    else
                    {
                        pms.Add(new SqlParameter("@AllotMoney" + i, item.AllotMoney));
                    }                              
                    pms.Add(new SqlParameter("@EditUID" + i, item.EditUID));
                    pms.Add(new SqlParameter("@BatchDetail_Id" + i, item.BatchDetail_Id));
                    pms.Add(new SqlParameter("@RewardUser_Id" + i, item.RewardUser_Id));
                    str.Append("update TPM_AllotReward set AllotMoney=@AllotMoney" + i + ",EditUID=@EditUID" + i + ",EditTime=getdate() where BatchDetail_Id=@BatchDetail_Id" + i + " and RewardUser_Id=@RewardUser_Id" +i+ " and IsDelete=0;");
                }
                result = SQLHelp.ExecuteNonQuery(str.ToString(), CommandType.Text, pms.ToArray());
            }
            return result;
        }
        #endregion
    }
}
