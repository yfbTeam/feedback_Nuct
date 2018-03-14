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
                str.Append(@" select r_bat.*,r_bat.Status as AuditStatus,b.Name as CreateName,ba.Year as BatYear,ba.Name as BatName
                   ,isnull((select sum(AllotMoney) from TPM_AllotReward where BatchDetail_Id=r_bat.Id and IsDelete=0),0)HasAllot ");
                if (ht["IsOnlyBase"].SafeToString() == "1") //查询关联表
                {
                    string IsAllotUser = ht["IsAllotUser"].SafeToString();
                    str.Append(@" ,uu.Name as ResponsName,al.Name as GidName,a.Year,l.Type as AchieveType
                    ,case when a.GPid=6 then bk.Name when a.GPid=4 then uu.Name else a.Name end as AchiveName
                    ,(select STUFF((select ',' + CAST(Major_Name AS NVARCHAR(MAX)) from Major where Id in(select value from func_split(a.DepartMent,',')) FOR xml path('')), 1, 1, '')) as Major_Name ");
                    if (IsAllotUser == "1")
                    {
                        str.Append(" ,au.Name as RUserName,allot.AllotMoney ");
                    }
                    str.Append(@" from TPM_RewardBatchDetail r_bat
                     inner join TPM_RewardBatch ba on r_bat.RewardBatch_Id=ba.Id
                     left join UserInfo b on r_bat.CreateUID=b.UniqueNo
                     left join TPM_AcheiveRewardInfo a on r_bat.Acheive_Id=a.Id 
                     left join UserInfo uu on a.ResponsMan=uu.UniqueNo
                     left join TPM_AcheiveLevel l on a.gpid=l.Id 
                     left join TPM_AcheiveLevel al on al.Id=a.Gid
                     left join TPM_BookStory bk on a.bookid=bk.id ");
                    if (IsAllotUser == "1")
                    {
                        str.Append(@" inner join TPM_AllotReward allot on allot.BatchDetail_Id=r_bat.Id and allot.IsDelete=0
	                                  left join TPM_RewardUserInfo ruser on ruser.Id=allot.RewardUser_Id
	                                  left join UserInfo au on au.UniqueNo=ruser.UserNo ");
                    }
                    if (ht.ContainsKey("AchiveName") && !string.IsNullOrEmpty(ht["AchiveName"].SafeToString()))
                    {
                        Where = " and AchiveName like N'%' + @AchiveName + '%'";
                        pms.Add(new SqlParameter("@AchiveName", ht["AchiveName"].ToString()));
                    }
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
                if (ht.ContainsKey("IsMoneyAllot") && !string.IsNullOrEmpty(ht["IsMoneyAllot"].SafeToString()))
                {
                    str.Append(" and ba.IsMoneyAllot=@IsMoneyAllot ");
                    pms.Add(new SqlParameter("@IsMoneyAllot", ht["IsMoneyAllot"].ToString()));
                }                
                if (ht.ContainsKey("Acheive_Id") && !string.IsNullOrEmpty(ht["Acheive_Id"].SafeToString()))
                {
                    str.Append(" and r_bat.Acheive_Id=@Acheive_Id ");
                    pms.Add(new SqlParameter("@Acheive_Id", ht["Acheive_Id"].ToString()));
                }
                if (ht.ContainsKey("Id") && !string.IsNullOrEmpty(ht["Id"].SafeToString()))
                {
                    str.Append(" and r_bat.Id=@Id ");
                    pms.Add(new SqlParameter("@Id", ht["Id"].ToString()));
                }
                if (ht.ContainsKey("GPid") && !string.IsNullOrEmpty(ht["GPid"].SafeToString()))
                {
                    str.Append(" and a.GPid=@GPid ");
                    pms.Add(new SqlParameter("@GPid", ht["GPid"].SafeToString()));
                }
                if (ht.ContainsKey("Gid") && !string.IsNullOrEmpty(ht["Gid"].SafeToString()))
                {
                    str.Append(" and a.Gid=@Gid ");
                    pms.Add(new SqlParameter("@Gid", ht["Gid"].SafeToString()));
                }
                if (ht.ContainsKey("Year") && !string.IsNullOrEmpty(ht["Year"].SafeToString()))
                {
                    str.Append(" and a.Year like N'%' + @Year + '%'");
                    pms.Add(new SqlParameter("@Year", ht["Year"].ToString().Replace("年", "")));
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

        #region 删除奖金批次详情
        public int Del_RewardBatchDetail(int itemid)
        {
            int result = 0;
            List<SqlParameter> pms = new List<SqlParameter>();
            StringBuilder str = new StringBuilder();
            str.Append(@"update TPM_RewardBatchDetail set IsDelete=1 where Id=@Id;
                         update TPM_AllotReward set IsDelete=1 where BatchDetail_Id=@Id;
                         update TPM_ModifyRecord set IsDelete=1 where RelationId=@Id");
            pms.Add(new SqlParameter("@Id", itemid));
            result = SQLHelp.ExecuteNonQuery(str.ToString(), CommandType.Text, pms.ToArray());
            return result;
        }
        #endregion

        #region 批量分配项目奖金
        public string BatchAllot_RewardBatchDetail(string BatchId, string BatchMoney, string LoginUID, string LoginName, string ModifyRecord)
        {
            SqlParameter[] param = {
                    new SqlParameter("@BatchId", BatchId),
                    new SqlParameter("@BatchMoney",BatchMoney),
                    new SqlParameter("@LoginUID", LoginUID),
                    new SqlParameter("@LoginName",LoginName),                    
                    new SqlParameter("@ModifyRecord",ModifyRecord)
            };
            object obj = SQLHelp.ExecuteScalar("BatchAllot_RewardBatchDetail", CommandType.StoredProcedure, param);
            return obj.ToString();
        }
        #endregion
    }
}
