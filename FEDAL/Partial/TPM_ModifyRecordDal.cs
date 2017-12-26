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
    public partial class TPM_ModifyRecordDal : BaseDal<TPM_ModifyRecord>, ITPM_ModifyRecordDal
    {
        public override DataTable GetListByPage(Hashtable ht, out int RowCount, bool IsPage = true, string Where = "")
        {
            RowCount = 0;
            List<SqlParameter> pms = new List<SqlParameter>();
            DataTable dt = new DataTable();
            try
            {
                StringBuilder str = new StringBuilder();
                str.Append(@" select rec.*,rea.EditReason from TPM_ModifyRecord rec
                            left join TPM_ModifyReason rea on rec.Reason_Id=rea.Id and rea.IsDelete=0
                            where rec.IsDelete=0 ");
                int StartIndex = 0;
                int EndIndex = 0;
                if (ht.ContainsKey("Acheive_Id") && !string.IsNullOrEmpty(ht["Acheive_Id"].SafeToString()))
                {
                    str.Append(" and rec.Acheive_Id=@Acheive_Id ");
                    pms.Add(new SqlParameter("@Acheive_Id", ht["Acheive_Id"].ToString()));
                }
                if (ht.ContainsKey("ModifyUID") && !string.IsNullOrEmpty(ht["ModifyUID"].SafeToString()))
                {
                    str.Append(" and rec.ModifyUID=@ModifyUID ");
                    pms.Add(new SqlParameter("@ModifyUID", ht["ModifyUID"].ToString()));
                }
                if (ht.ContainsKey("Id") && !string.IsNullOrEmpty(ht["Id"].SafeToString()))
                {
                    str.Append(" and rec.Id=@Id ");
                    pms.Add(new SqlParameter("@Id", ht["Id"].ToString()));
                }
                if (ht.ContainsKey("Type") && !string.IsNullOrEmpty(ht["Type"].SafeToString()))
                {
                    str.Append(" and rec.Type=@Type ");
                    pms.Add(new SqlParameter("@Type", ht["Type"].ToString()));
                }
                if (ht.ContainsKey("RelationId") && !string.IsNullOrEmpty(ht["RelationId"].SafeToString()))
                {
                    str.Append(" and rec.RelationId=@RelationId ");
                    pms.Add(new SqlParameter("@RelationId", ht["RelationId"].ToString()));
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

        #region 添加奖金历史分配信息
        public int Add_ModifyRecord(int reasonId,List<TPM_ModifyRecord> items)
        {
            int result = 0;
            List<SqlParameter> pms = new List<SqlParameter>();
            StringBuilder str = new StringBuilder();
            if (items.Count() > 0)
            {
                pms.Add(new SqlParameter("@Reason_Id", reasonId));
                for (int i = 0; i < items.Count; i++)
                {
                    TPM_ModifyRecord item = items[i];
                    pms.Add(new SqlParameter("@Type" + i, item.Type));
                    pms.Add(new SqlParameter("@RelationId" + i, item.RelationId));
                    pms.Add(new SqlParameter("@Acheive_Id" + i, item.Acheive_Id));
                    pms.Add(new SqlParameter("@Content" + i, item.Content));                    
                    pms.Add(new SqlParameter("@ModifyUID" + i, item.ModifyUID));
                    pms.Add(new SqlParameter("@CreateUID" + i, item.CreateUID));
                    str.Append(@"insert into TPM_ModifyRecord(Type,RelationId,Acheive_Id,Content,Reason_Id,ModifyUID,CreateUID)
                         values(@Type" + i + ",@RelationId" + i + ",@Acheive_Id" + i + ",@Content" + i + ",@Reason_Id,@ModifyUID" + i + ",@CreateUID" + i+ ");");
                }
                result = SQLHelp.ExecuteNonQuery(str.ToString(), CommandType.Text, pms.ToArray());
            }
            return result;
        }
        #endregion
    }
}
