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
                str.Append(@" select r_bat.*,r_bat.Status as AuditStatus,b.Name as CreateName
                   ,isnull((select sum(AllotMoney) from TPM_AllotReward where BatchDetail_Id=r_bat.Id),0)HasAllot ");
                if (ht["IsOnlyBase"].SafeToString() == "1") //查询关联表
                {
                    str.Append(@" ,uu.Name as ResponsName,al.Name as GidName,a.Year
                    ,case when a.GPid=6 then bk.Name when a.GPid=4 then uu.Name else a.Name end as AchiveName
                    ,(select STUFF((select ',' + CAST(Major_Name AS NVARCHAR(MAX)) from Major where Id in(select value from func_split(a.DepartMent,',')) FOR xml path('')), 1, 1, '')) as Major_Name                   
                     from TPM_RewardBatchDetail r_bat
                     inner join TPM_RewardBatch ba on r_bat.RewardBatch_Id=ba.Id
                     left join UserInfo b on r_bat.CreateUID=b.UniqueNo
                     left join TPM_AcheiveRewardInfo a on r_bat.Acheive_Id=a.Id 
                     left join UserInfo uu on a.ResponsMan=uu.UniqueNo
                     left join TPM_AcheiveLevel al on al.Id=a.Gid
                     left join TPM_BookStory bk on a.bookid=bk.id ");
                }
                else //只查询基础表
                {
                    str.Append(@" from TPM_RewardBatchDetail r_bat 
                                inner join TPM_RewardBatch ba on r_bat.RewardBatch_Id=ba.Id
                                left join UserInfo b on r_bat.CreateUID=b.UniqueNo ");
                }
                str.Append(@" where r_bat.IsDelete=0 and ba.IsDelete=0 ");
                int StartIndex = 0;
                int EndIndex = 0;
                if (ht.ContainsKey("RewardBatch_Id") && !string.IsNullOrEmpty(ht["RewardBatch_Id"].SafeToString()))
                {
                    str.Append(" and r_bat.RewardBatch_Id=@RewardBatch_Id ");
                    pms.Add(new SqlParameter("@RewardBatch_Id", ht["RewardBatch_Id"].ToString()));
                }                
                if (ht.ContainsKey("Acheive_Id") && !string.IsNullOrEmpty(ht["Acheive_Id"].SafeToString()))
                {
                    str.Append(" and r_bat.Id=@Acheive_Id ");
                    pms.Add(new SqlParameter("@Acheive_Id", ht["Acheive_Id"].ToString()));
                }
                if (ht.ContainsKey("Id") && !string.IsNullOrEmpty(ht["Id"].SafeToString()))
                {
                    str.Append(" and r_bat.Id=@Id ");
                    pms.Add(new SqlParameter("@Id", ht["Id"].ToString()));
                }
                if (ht.ContainsKey("AuditStatus") && !string.IsNullOrEmpty(ht["AuditStatus"].SafeToString()))
                {
                    str.Append(" and r_bat.Status " + ht["AuditStatus"].ToString());
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

        #region 添加奖金批次详情
        public int Add_RewardBatchDetail(int batchid, string achieve_Ids, string createUID)
        {
            int result = 0;
            List<SqlParameter> pms = new List<SqlParameter>();
            StringBuilder str = new StringBuilder();
            pms.Add(new SqlParameter("@RewardBatch_Id", batchid));
            pms.Add(new SqlParameter("@CreateUID", createUID));
            string[] achArray = achieve_Ids.Split(',');
            if (achArray.Length > 0)
            {
                for (int i = 0; i < achArray.Length; i++)
                {
                    pms.Add(new SqlParameter("@Acheive_Id" + i, achArray[i]));                   
                    string achsql = "select Id from TPM_RewardBatchDetail where RewardBatch_Id=@RewardBatch_Id and Acheive_Id=@Acheive_Id" + i + " and IsDelete=0";
                    int allotid = Convert.ToInt32(SQLHelp.ExecuteScalar(achsql, CommandType.Text, pms.ToArray()));
                    if (allotid<=0)
                    {
                        str.Append(@"insert into TPM_RewardBatchDetail(RewardBatch_Id,Acheive_Id,CreateUID) 
                            values(@RewardBatch_Id,@Acheive_Id" + i + ",@CreateUID);");
                    }                   
                }
                result = SQLHelp.ExecuteNonQuery(str.ToString(), CommandType.Text, pms.ToArray());
            }
            return result;
        }
        #endregion    
    }
}
