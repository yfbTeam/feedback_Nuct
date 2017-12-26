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
    public partial class TPM_AcheiveMemberDal : BaseDal<TPM_AcheiveMember>, ITPM_AcheiveMemberDal
    {
        public override DataTable GetListByPage(Hashtable ht, out int RowCount, bool IsPage = true, string Where = "")
        {
            RowCount = 0;
            List<SqlParameter> pms = new List<SqlParameter>();
            DataTable dt = new DataTable();
            try
            {
                StringBuilder str = new StringBuilder();
                str.Append(@"select am.*,u.Name as CreateName,m.Major_Name as MajorName
                               from TPM_AcheiveMember am
                               inner join UserInfo u on u.UniqueNo=am.MemberNo                   
                               left join Major m on u.Major_ID=m.Id  
                               where am.IsDelete=0 and 1=1");              
                int StartIndex = 0;
                int EndIndex = 0;
                if (ht.ContainsKey("Id") && !string.IsNullOrEmpty(ht["Id"].SafeToString()))
                {
                    str.Append(" and am.Id=@Id ");
                    pms.Add(new SqlParameter("@Id", ht["Id"].ToString()));
                }
                if (ht.ContainsKey("AcheiveReward_Id") && !string.IsNullOrEmpty(ht["AcheiveReward_Id"].SafeToString()))
                {
                    str.Append(" and am.AcheiveReward_Id=@AcheiveReward_Id ");
                    pms.Add(new SqlParameter("@AcheiveReward_Id", ht["AcheiveReward_Id"].ToString()));
                }                
                if (IsPage)
                {
                    StartIndex = Convert.ToInt32(ht["StartIndex"].ToString());
                    EndIndex = Convert.ToInt32(ht["EndIndex"].ToString());
                }
                dt = SQLHelp.GetListByPage("(" + str.ToString() + ")", Where, "Sort", StartIndex,EndIndex, IsPage, pms.ToArray(), out RowCount);
            }
            catch (Exception ex)
            {
                LogService.WriteErrorLog(ex.Message);
            }
            return dt;
        }

        #region 批量修改成员
        public int Edit_AcheiveMember(List<TPM_AcheiveMember> items, int AcheiveReward_Id)
        {
            int result = 1;           
            List<SqlParameter> up_pms = new List<SqlParameter>(), pms = new List<SqlParameter>();
            up_pms.Add(new SqlParameter("@AcheiveReward_Id", AcheiveReward_Id));
            SQLHelp.ExecuteNonQuery("update TPM_AcheiveMember set IsDelete=1 where AcheiveReward_Id=@AcheiveReward_Id ", CommandType.Text, up_pms.ToArray());
            string str = "";
            if (items.Count() > 0)
            {
                for (int i = 0; i < items.Count; i++)
                {
                    TPM_AcheiveMember item = items[i];
                    str += "update TPM_AcheiveMember set Score=@Score" + i + ",Sort=@Sort" + i + ",EditUID=@EditUID" + i + ",IsDelete=0 where Id=@Id" + i + ";";
                    pms.Add(new SqlParameter("@Id" + i, item.Id));
                    if (item.Score == null)
                    {
                        pms.Add(new SqlParameter("@Score" + i, DBNull.Value));
                    }else
                    {
                        pms.Add(new SqlParameter("@Score" + i, item.Score));
                    }
                    pms.Add(new SqlParameter("@Sort" + i, item.Sort));
                    pms.Add(new SqlParameter("@EditUID" + i, item.EditUID));
                }
                result= SQLHelp.ExecuteNonQuery(str, CommandType.Text, pms.ToArray());
            }
            return result;
        }
        #endregion
    }
}
