using FEIDAL;
using FEModel;
using FEUtility;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
namespace FEDAL
{
    public partial class TPM_AcheiveRewardInfoDal : BaseDal<TPM_AcheiveRewardInfo>, ITPM_AcheiveRewardInfoDal
    {
        public override DataTable GetListByPage(Hashtable ht, out int RowCount, bool IsPage = true, string Where = "")
        {
            RowCount = 0;
            DataTable dt = new DataTable();
            List<SqlParameter> pms = new List<SqlParameter>();
            try
            {
                StringBuilder str = new StringBuilder();
                str.Append(@" select *,
                         case when Status<7 then Status
                         when Status>=7 and IsMoneyAllot=0 then 7
                         when Status>=7 and IsMoneyAllot=1 then
                            case when 2 in(select value from func_split(AuditSts,',')) then 11 
                             when 0 in (select value from func_split(AuditSts,',')) then 9
                             when 10 in(select value from func_split(AuditSts,',')) then 8 
	                         when 1 in (select value from func_split(AuditSts,',')) then 10 else 12 end end as ComStatus
                    from ( ");
                str.Append(@" select a.*,uu.Name as ResponsName,u.Name as CreateName,l.name as GName,al.Name as GidName,
                    case when a.GPid=6 then bk.Name when a.GPid=4 then uu.Name else a.Name end as AchiveName,
                    l.Type as AchieveType,ll.Name as LevelName,r.Name as RewadName,
                    (select STUFF((select ',' + CAST(Major_Name AS NVARCHAR(MAX)) from Major where Id in(select value from func_split(a.DepartMent,',')) FOR xml path('')), 1, 1, '')) as Major_Name,                   
                    case when a.GPid=1 then isnull((ran.Score),0) else r.Score end as TotalScore,ran.Name RankName,
                    r.ScoreType,(select top 1 Money from TPM_RewardBatch where Reward_Id=r.Id and IsDelete=0 order by Id) as Award
                    ,bk.Name as BookName,bk.BookType,case when bk.BookType=1 then '无' else bk.ISBN end as ISBN                  
                    ,isnull((select IsMoneyAllot from TPM_RewardEdition where LID=a.Gid and convert(varchar(10),a.DefindDate,21) between convert(varchar(10),BeginTime,21) and convert(varchar(10),EndTime,21)),0)as IsMoneyAllot
                    ,STUFF((select ',' + CAST(isnull(aud.Status,10) AS NVARCHAR(MAX)) from TPM_RewardBatch r_bat
                    left join TPM_AuditReward aud on r_bat.Id=aud.RewardBatch_Id and aud.Acheive_Id=a.Id and aud.IsDelete=0
                    where r_bat.IsDelete=0 and r_bat.Reward_Id=a.Rid FOR xml path('')), 1, 1, '') as AuditSts ");
                if (ht.ContainsKey("LoginMajor_ID") && !string.IsNullOrEmpty(ht["LoginMajor_ID"].SafeToString()))
                {
                    str.Append(@",(select count(1) from TPM_RewardUserInfo ruser left join UserInfo u on ruser.UserNo = u.UniqueNo
             where ruser.IsDelete=0 and ruser.RIId=a.Id and u.Major_ID=@LoginMajor_ID) MajorCount ");
                    pms.Add(new SqlParameter("@LoginMajor_ID", ht["LoginMajor_ID"].SafeToString()));
                }
                if (ht.ContainsKey("MyUno") && !string.IsNullOrEmpty(ht["MyUno"].SafeToString()))
                {
                    str.Append(" ,case when a.Status>6 then (select top 1 Score from TPM_RewardUserInfo where RIId=a.Id and UserNo=@MyUno) else NULL end as SelfScore ");
                }
                str.Append(@" from TPM_AcheiveRewardInfo a 
                    inner join UserInfo u on a.CreateUID=u.UniqueNo 
                    left join UserInfo uu on a.ResponsMan=uu.UniqueNo
                    left join Major m on a.DepartMent=m.Id 
                    left join TPM_AcheiveLevel l on a.gpid=l.Id  
                    left join TPM_AcheiveLevel al on al.Id=a.Gid
                    left join TPM_RewardLevel ll on a.Lid=ll.Id 
                    left join TPM_RewardInfo r on a.Rid=r.Id 
                    left join TMP_RewardRank ran on a.Sort=ran.Id
                    left join TPM_BookStory bk on a.bookid=bk.id where a.IsDelete=0 ");
                int StartIndex = 0;
                int EndIndex = 0;
                if (ht.ContainsKey("Status") && !string.IsNullOrEmpty(ht["Status"].SafeToString()))
                {
                    str.Append(" and a.Status in (" + ht["Status"].SafeToString() + ")");
                }
                if (ht.ContainsKey("Status_Com") && !string.IsNullOrEmpty(ht["Status_Com"].SafeToString()))
                {
                    str.Append(" and a.Status" + ht["Status_Com"].SafeToString());
                }
                if (ht.ContainsKey("Name") && !string.IsNullOrEmpty(ht["Name"].SafeToString()))
                {
                    str.Append(" and a.Name like '%" + ht["Name"].SafeToString() + "%'");
                }
                if (ht.ContainsKey("ResponName") && !string.IsNullOrEmpty(ht["ResponName"].SafeToString()))
                {
                    str.Append(" and uu.Name like '%" + ht["ResponName"].SafeToString() + "%'"); //负责人名称
                }
                if (ht.ContainsKey("MyUno") && !string.IsNullOrEmpty(ht["MyUno"].SafeToString()))
                {
                    str.Append(" and (a.ResponsMan=@MyUno or (a.Status>6 and a.Id in(select distinct RIId from TPM_RewardUserInfo where IsDelete = 0 and UserNo=@MyUno)))");
                    pms.Add(new SqlParameter("@MyUno", ht["MyUno"].SafeToString()));
                }
                if (ht.ContainsKey("CreateUID") && !string.IsNullOrEmpty(ht["CreateUID"].SafeToString()))
                {
                    str.Append(" and a.CreateUID =@CreateUID ");
                    pms.Add(new SqlParameter("@CreateUID", ht["CreateUID"].SafeToString()));
                }
                if (ht.ContainsKey("Id") && !string.IsNullOrEmpty(ht["Id"].SafeToString()))
                {
                    str.Append(" and a.Id =@Id ");
                    pms.Add(new SqlParameter("@Id", ht["Id"].SafeToString()));
                }
                if (ht.ContainsKey("GPid") && !string.IsNullOrEmpty(ht["GPid"].SafeToString()))
                {
                    str.Append(" and a.GPid =@GPid ");
                    pms.Add(new SqlParameter("@GPid", ht["GPid"].SafeToString()));
                }
                if (ht.ContainsKey("Gid") && !string.IsNullOrEmpty(ht["Gid"].SafeToString()))
                {
                    str.Append(" and a.Gid=@Gid ");
                    pms.Add(new SqlParameter("@Gid", ht["Gid"].SafeToString()));
                }                
                if (ht.ContainsKey("BookId") && !string.IsNullOrEmpty(ht["BookId"].SafeToString()))
                {
                    str.Append(" and a.BookId =@BookId ");
                    pms.Add(new SqlParameter("@BookId", ht["BookId"].SafeToString()));
                }
                if (ht.ContainsKey("DepartMent") && !string.IsNullOrEmpty(ht["DepartMent"].SafeToString()))
                {
                    str.Append(" and a.DepartMent =@DepartMent ");
                    pms.Add(new SqlParameter("@DepartMent", ht["DepartMent"].SafeToString()));
                }
                if (ht.ContainsKey("BeginTime") && !string.IsNullOrEmpty(ht["BeginTime"].SafeToString()))
                {
                    str.Append(" and a.CreateTime > '" + ht["BeginTime"].SafeToString() + "'");
                }
                if (ht.ContainsKey("EndTime") && !string.IsNullOrEmpty(ht["EndTime"].SafeToString()))
                {
                    str.Append(" and a.CreateTime < '" + ht["EndTime"].SafeToString() + "'");
                }
                if (ht.ContainsKey("Major_ID") && !string.IsNullOrEmpty(ht["Major_ID"].SafeToString()))
                {
                    str.Append(@" and a.Id in(select distinct ruser.RIId from TPM_RewardUserInfo ruser
                              left join UserInfo u on ruser.UserNo = u.UniqueNo
                              where ruser.IsDelete = 0 and ruser.RIId!= 0 and u.Major_ID=@Major_ID)");
                    pms.Add(new SqlParameter("@Major_ID", ht["Major_ID"].SafeToString()));
                }
                if (ht.ContainsKey("AuditMajor_ID") && !string.IsNullOrEmpty(ht["AuditMajor_ID"].SafeToString())) //业绩审核处的查询
                {
                    str.Append(@" and (a.Status in(1,5) or a.Id in(select distinct Acheive_Id from TPM_AuditReward where IsDelete=0 and Status=1))");
                    str.Append(@" and (a.GPid in("+ ht["Level_AllIds"].SafeToString() + ") or (a.GPid in ("+ ht["Level_DepartIds"].SafeToString() + @") and a.Id in(select distinct ruser.RIId from TPM_RewardUserInfo ruser
                              left join UserInfo u on ruser.UserNo = u.UniqueNo
                              where ruser.IsDelete = 0 and ruser.RIId!= 0 and u.Major_ID=@AuditMajor_ID))) ");
                    pms.Add(new SqlParameter("@AuditMajor_ID", ht["AuditMajor_ID"].SafeToString()));
                }
                if (ht.ContainsKey("MyAch_LoginUID") && !string.IsNullOrEmpty(ht["MyAch_LoginUID"].SafeToString())) //我的业绩处的查询
                {
                    str.Append(@" and ((a.GPid!=2 and a.Status>2) or (a.GPid=2 and ((a.CreateUID=@MyAch_LoginUID) or (a.CreateUID!=@MyAch_LoginUID and a.Status>0)))) ");
                    pms.Add(new SqlParameter("@MyAch_LoginUID", ht["MyAch_LoginUID"].SafeToString()));
                }
                if (ht.ContainsKey("Respon_LoginUID") && !string.IsNullOrEmpty(ht["Respon_LoginUID"].SafeToString())) //首页统计信息-负责人待审核
                {
                    str.Append(@" and a.ResponsMan=@Respon_LoginUID and ((a.Status=1 and a.GPid=2) or a.Status=5 or a.Id in(select distinct Acheive_Id from TPM_AuditReward where IsDelete=0 and Status=1))");
                    pms.Add(new SqlParameter("@Respon_LoginUID", ht["Respon_LoginUID"].SafeToString()));
                }
                if (ht.ContainsKey("MyIndex_LoginUID") && !string.IsNullOrEmpty(ht["MyIndex_LoginUID"].SafeToString()))//首页统计信息-我的业绩
                {
                    str.Append(" and a.Status>6 and a.Id in(select distinct RIId from TPM_RewardUserInfo where IsDelete =0 and UserNo=@MyIndex_LoginUID)");
                    pms.Add(new SqlParameter("@MyIndex_LoginUID", ht["MyIndex_LoginUID"].SafeToString()));
                }
                if (IsPage)
                {
                    StartIndex = Convert.ToInt32(ht["StartIndex"].ToString());
                    EndIndex = Convert.ToInt32(ht["EndIndex"].ToString());
                }
                str.Append(@" ) Temp ");
                dt = SQLHelp.GetListByPage("(" + str.ToString() + ")", Where, "", StartIndex, EndIndex, IsPage, pms.ToArray(), out RowCount);
            }
            catch (Exception ex)
            {
                LogService.WriteErrorLog(ex.Message);
            }
            return dt;
        }
        public string AddAcheiveRewardInfo(TPM_AcheiveRewardInfo entity)
        {

            List<SqlParameter> param = new List<SqlParameter>() {
                                  new SqlParameter("@Id",entity.Id),
                                  new SqlParameter("@Name",entity.Name),                                 
                                  new SqlParameter("@GPid",entity.GPid),                                  
                                  new SqlParameter("@TeaUNo",entity.TeaUNo),                                
                                  new SqlParameter("@Year",entity.Year),
                                  new SqlParameter("@ResponsMan",entity.ResponsMan),
                                  new SqlParameter("@DepartMent",entity.DepartMent),
                                  new SqlParameter("@FileEdionNo",entity.FileEdionNo),
                                  new SqlParameter("@FileNames",entity.FileNames),
                                  new SqlParameter("@DefindDepart",entity.DefindDepart),                                  
                                  new SqlParameter("@FileInfo",entity.FileInfo),
                                  new SqlParameter("@Status",entity.Status),
                                  new SqlParameter("@CreateUID",entity.CreateUID)
                                  };
            if (entity.Gid == 0)
            {
                param.Add(new SqlParameter("@Gid",DBNull.Value));
            }
            else
            {
                param.Add(new SqlParameter("@Gid", entity.Gid));
            }
            if (entity.BookId == 0)
            {
                param.Add(new SqlParameter("@BookId", DBNull.Value));
            }
            else
            {
                param.Add(new SqlParameter("@BookId", entity.BookId));
            }

            if (entity.Lid == 0)
            {
                param.Add(new SqlParameter("@Lid", DBNull.Value));
            }
            else
            {
                param.Add(new SqlParameter("@Lid", entity.Lid));
            }

            if (entity.Rid == 0)
            {
                param.Add(new SqlParameter("@Rid", DBNull.Value));
            }
            else
            {
                param.Add(new SqlParameter("@Rid", entity.Rid));
            }
            if (entity.Sort == 0)
            {
                param.Add(new SqlParameter("@Sort", DBNull.Value));
            }
            else
            {
                param.Add(new SqlParameter("@Sort", entity.Sort));
            }
            if (entity.DefindDate == null)
            {
                param.Add(new SqlParameter("@DefindDate", DBNull.Value));
            }
            else
            {
                param.Add(new SqlParameter("@DefindDate", entity.DefindDate));
            }           
            object obj = SQLHelp.ExecuteScalar("TPM_AddAcheiveRewardInfo", CommandType.StoredProcedure, param.ToArray());
            return obj.ToString();
        }

        #region 修改业绩状态
        public int Edit_AchieveStatus(int id,int status)
        {
            string str = "update TPM_AcheiveRewardInfo set Status=@Status where Id=@Id";
            List<SqlParameter> pms = new List<SqlParameter>();
            pms.Add(new SqlParameter("@Id", id));
            pms.Add(new SqlParameter("@Status", status));
            return SQLHelp.ExecuteNonQuery(str, CommandType.Text, pms.ToArray());
        }
        #endregion

        #region 修改业绩状态
        public int DelAcheiveRewardInfo(int id)
        {
            string str = @"update TPM_AcheiveRewardInfo set IsDelete=1 where Id=@Id;
                          update TPM_RewardUserInfo set IsDelete=1 where RIId=@Id";
            List<SqlParameter> pms = new List<SqlParameter>();
            pms.Add(new SqlParameter("@Id", id));            
            return SQLHelp.ExecuteNonQuery(str, CommandType.Text, pms.ToArray());
        }
        #endregion
    }
}
