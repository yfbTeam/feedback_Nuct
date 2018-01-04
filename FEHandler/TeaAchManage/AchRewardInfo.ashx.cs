using FEBLL;
using FEDAL;
using FEModel;
using FEUtility;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace FEHandler.TeaAchManage
{
    /// <summary>
    /// AchRewardInfo 的摘要说明
    /// </summary>
    public class AchRewardInfo : IHttpHandler
    {
        //业绩等级
        TPM_AcheiveRewardInfoService bll = new TPM_AcheiveRewardInfoService();
        TPM_BookStoryService bookbll = new TPM_BookStoryService();
        TPM_RewardUserInfoService userbll = new TPM_RewardUserInfoService();
        TMP_RewardRankService rankbll = new TMP_RewardRankService();
        TPM_RewardBatchService rbatchbll = new TPM_RewardBatchService();
        TPM_AuditRewardService rauditbll = new TPM_AuditRewardService();
        TPM_ModifyRecordService mrecordbll = new TPM_ModifyRecordService();
        JsonModel jsonModel = JsonModel.get_jsonmodel(0, "success", "");
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string func = context.Request["Func"];
            string result = string.Empty;
            try
            {
                switch (func)
                {
                    /*业绩*/
                    case "GetAcheiveRewardInfoData":
                        GetAcheiveRewardInfoData(context);
                        break;
                    case "AddAcheiveRewardInfoData":
                        AddAcheiveRewardInfoData(context);
                        break;
                    case "DelAcheiveRewardInfo":
                        DelAcheiveRewardInfo(context);
                        break;
                    case "CheckAcheiveRewardInfoData":
                        CheckAcheiveRewardInfoData(context);
                        break;
                    case "Add_AcheiveAllot":
                        Add_AcheiveAllot(context);
                        break;
                    /*教材*/
                    case "AddTPM_BookStory":
                        AddTPM_BookStory(context);
                        break;
                    case "GetTPM_BookStory":
                        GetTPM_BookStory(context);
                        break;
                    case "CheckTPM_BookStory":
                        CheckTPM_BookStory(context);
                        break;
                    case "Del_BookStory":
                        Del_BookStory(context);
                        break;
                    /*业绩分配用户信息*/
                    case "GetTPM_UserInfo":
                        GetTPM_UserInfo(context);
                        break;
                    case "AddTPM_UserInfo":
                        AddTPM_UserInfo(context);
                        break;
                    case "DelTPM_UserInfo":
                        DelTPM_UserInfo(context);
                        break;
                    /*奖励名次*/
                    case "GetRank":
                        GetRank(context);
                        break;
                    case "GenerateRank":
                        GenerateRank(context);
                        break;
                    case "OperRank":
                        OperRank(context);
                        break;                        
                    case "DelRank":
                        DelRank(context);
                        break;                                      
                    case "Get_Sys_Document": //文件
                        Get_Sys_Document(context);
                        break;
                    /*追加奖金*/
                    case "Get_RewardBatchData":
                        Get_RewardBatchData(context);
                        break;
                    case "Get_AllotReward":
                        Get_AllotReward(context);
                        break;
                    case "Oper_AuditAllotReward":
                        Oper_AuditAllotReward(context);
                        break;
                    case "Admin_EditAllotReward":
                        Admin_EditAllotReward(context);
                        break;
                    case "Check_AuditReward":
                        Check_AuditReward(context);
                        break;
                    /*分配历史记录*/
                    case "Get_ModifyRecordData":
                        Get_ModifyRecordData(context);
                        break;
                    default:
                        jsonModel = JsonModel.get_jsonmodel(5, "没有此方法", "");
                        break;
                }
                LogService.WriteLog(func);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                jsonModel = JsonModel.get_jsonmodel(7, "出现异常,请通知管理员", "");
            }
            finally
            {
                result = "{\"result\":" + Constant.jss.Serialize(jsonModel) + "}";
                context.Response.Write(result);
                context.Response.End();
            }
        }
        #region 业绩信息
        private void GetAcheiveRewardInfoData(HttpContext context)
        {
            try
            {
                bool IsPage = true;
                if (context.Request["IsPage"].SafeToString() != "" && context.Request["IsPage"] != "undefined")
                {
                    IsPage = Convert.ToBoolean(context.Request["IsPage"]);
                }
                Hashtable ht = new Hashtable();
                ht.Add("PageIndex", context.Request["PageIndex"].SafeToString());
                ht.Add("PageSize", context.Request["PageSize"].SafeToString());
                ht.Add("Status", context.Request["Status"].SafeToString());
                ht.Add("Status_Com", context.Request["Status_Com"].SafeToString());                
                ht.Add("Name", context.Request["Name"].SafeToString());
                ht.Add("ResponName", context.Request["ResponName"].SafeToString());
                ht.Add("CreateUID", context.Request["CreateUID"].SafeToString());
                ht.Add("MyUno", context.Request["MyUno"].SafeToString());
                ht.Add("Id", context.Request["Id"].SafeToString());
                ht.Add("GPid", context.Request["AchieveLevel"].SafeToString());
                ht.Add("Gid", context.Request["Gid"].SafeToString());                
                ht.Add("BookId", context.Request["BookId"].SafeToString());                
                ht.Add("DepartMent", context.Request["DepartMent"].SafeToString());
                ht.Add("BeginTime", context.Request["BeginTime"].SafeToString());
                ht.Add("EndTime", context.Request["EndTime"].SafeToString());
                ht.Add("Major_ID", context.Request["Major_ID"].SafeToString());
                ht.Add("LoginMajor_ID", context.Request["LoginMajor_ID"].SafeToString());
                ht.Add("AuditMajor_ID", context.Request["AuditMajor_ID"].SafeToString());//按院系查询的Major_ID                
                ht.Add("Level_DepartIds", context.Request["Level_DepartIds"].SafeToString()); //业绩审核，按院系查询的十大业绩Id
                ht.Add("Level_AllIds", context.Request["Level_AllIds"].SafeToString());//业绩审核，按全校查询的十大业绩Id
                ht.Add("MyAch_LoginUID", context.Request["MyAch_LoginUID"].SafeToString());//我的业绩处的查询           
                jsonModel = bll.GetPage(ht, IsPage);

            }
            catch (Exception ex)
            {
                jsonModel = new JsonModel()
                {
                    errNum = 400,
                    errMsg = ex.Message,
                    retData = ""
                };
                LogService.WriteErrorLog(ex.Message);
            }
        }
        private void CheckAcheiveRewardInfoData(HttpContext context)
        {
            int Id = Convert.ToInt32(context.Request["Id"]);
            TPM_AcheiveRewardInfo model = bll.GetEntityById(Id).retData as TPM_AcheiveRewardInfo;
            int oldstatus =Convert.ToInt32(model.Status);
            model.Status = Convert.ToInt32(context.Request["Status"]);
            jsonModel = bll.Update(model);
            string hisrecord= RequestHelper.string_transfer(context.Request, "HisRecord");
            if (oldstatus!=7&&model.Status==7&&!string.IsNullOrEmpty(hisrecord))
            {
                List<TPM_ModifyRecord> reclist = JsonConvert.DeserializeObject<List<TPM_ModifyRecord>>(hisrecord);
                foreach (TPM_ModifyRecord item in reclist)
                {                   
                    jsonModel = mrecordbll.Add(item);                         
                }
            }
        }
        private void AddAcheiveRewardInfoData(HttpContext context)
        {
            try
            {
                TPM_AcheiveRewardInfo model = null;
                int Id = RequestHelper.int_transfer(context.Request, "Id");
                int BookId = RequestHelper.int_transfer(context.Request, "BookId");
                bool isadd = Id == 0;
                if (Id == 0)
                {
                    model = new TPM_AcheiveRewardInfo();
                    model.GPid = RequestHelper.int_transfer(context.Request, "Group");
                    model.CreateUID = context.Request["CreateUID"].SafeToString();
                }
                else
                {
                    model = bll.GetEntityById(Id).retData as TPM_AcheiveRewardInfo;
                }
               
                model.Gid = RequestHelper.int_transfer(context.Request, "Gid");
                model.Lid = RequestHelper.int_transfer(context.Request, "Lid");
                model.Rid = RequestHelper.int_transfer(context.Request, "Rid");
                string Year = context.Request["Year"].SafeToString();
                model.Name = context.Request["Name"].SafeToString();
                string defindDate = context.Request["DefindDate"];
                if (!string.IsNullOrEmpty(defindDate))
                {
                    model.DefindDate = RequestHelper.DateTime_transfer(context.Request, "DefindDate");
                }else
                {
                    model.DefindDate = null;
                }                
                model.DefindDepart = context.Request["DefindDepart"].SafeToString();
                model.DepartMent = context.Request["DepartMent"].SafeToString();
                model.FileEdionNo = context.Request["FileEdionNo"].SafeToString();
                model.FileInfo = context.Request["FileInfo"].SafeToString();
                model.FileNames = context.Request["FileNames"].SafeToString();
                model.ResponsMan = context.Request["ResponsMan"].SafeToString();
                model.Sort = RequestHelper.int_transfer(context.Request, "Sort"); 
                model.Status = RequestHelper.int_transfer(context.Request, "Status");
                model.TeaUNo = context.Request["TeaUNo"].SafeToString();
                int oldbookid =Convert.ToInt32(model.BookId);
                model.BookId = BookId;
                if (Year.Length > 0)
                {
                    model.Year = Year.Replace("年", "");
                }
                else
                    model.Year = "";
                string memberStr = RequestHelper.string_transfer(context.Request, "MemberStr");
                string MemberEdit = RequestHelper.string_transfer(context.Request, "MemberEdit");
                string add_Path= RequestHelper.string_transfer(context.Request, "Add_Path");
                string edit_PathId = RequestHelper.string_transfer(context.Request, "Edit_PathId");
                if (Id == 0)
                {
                    jsonModel = bll.TPM_AcheiveLevelAdd(model);
                    Id = Convert.ToInt32(jsonModel.retData);                    
                }
                else
                {
                    jsonModel = bll.TPM_AcheiveLevelAdd(model);
                }
                if (jsonModel.errNum == 0)
                {
                    int achieveType= RequestHelper.int_transfer(context.Request, "AchieveType");
                    if (achieveType == 3)//教材建设类
                    {
                        if(isadd||(!isadd&& BookId !=0&& BookId!= oldbookid)) //添加 或 教材修改了才需要更新数据
                        {
                            jsonModel = bll.Edit_AcheiveMember(null, Id, BookId);
                        }
                    }else
                    {
                        if (!isadd)
                        {
                            List<TPM_RewardUserInfo> editlist = new List<TPM_RewardUserInfo>();
                            if (!string.IsNullOrEmpty(MemberEdit))
                            {
                                editlist = JsonConvert.DeserializeObject<List<TPM_RewardUserInfo>>(MemberEdit);
                            }
                            jsonModel = bll.Edit_AcheiveMember(editlist, Id);
                        }
                        if (!string.IsNullOrEmpty(memberStr))
                        {
                            List<TPM_RewardUserInfo> memlist = JsonConvert.DeserializeObject<List<TPM_RewardUserInfo>>(memberStr);
                            foreach (TPM_RewardUserInfo item in memlist)
                            {
                                item.RIId = Id;
                                jsonModel = new TPM_RewardUserInfoService().Add(item); //数据库插入                           
                            }
                        }
                    }                    
                    if(!string.IsNullOrEmpty(add_Path)|| !string.IsNullOrEmpty(edit_PathId))
                    {
                        List<Sys_Document> pathlist = new List<Sys_Document>();
                        if (!string.IsNullOrEmpty(add_Path))
                        {
                            pathlist = JsonConvert.DeserializeObject<List<Sys_Document>>(add_Path);
                        }                         
                        new Sys_DocumentService().OperDocument(pathlist, edit_PathId, Id);
                    }                               
                }
            }
            catch (Exception ex)
            {
                jsonModel = new JsonModel()
                {
                    errNum = 400,
                    errMsg = ex.Message,
                    retData = ""
                };
                LogService.WriteErrorLog(ex.Message);
            }
        }
        private void DelAcheiveRewardInfo(HttpContext context)
        {
            try
            {
                int Id = Convert.ToInt32(context.Request["ItemId"]);
                jsonModel = bll.DelAcheiveRewardInfo(Id);
            }
            catch (Exception ex)
            {
                jsonModel = new JsonModel()
                {
                    errNum = 400,
                    errMsg = ex.Message,
                    retData = ""
                };
                LogService.WriteErrorLog(ex.Message);
            }
        }

        #region 保存业绩分配信息
        private void Add_AcheiveAllot(HttpContext context)
        {
            try
            {
                TPM_AcheiveRewardInfo model = null;
                int Id = RequestHelper.int_transfer(context.Request, "Id");
                model = bll.GetEntityById(Id).retData as TPM_AcheiveRewardInfo;
                if (model!=null)
                {
                    if (!string.IsNullOrEmpty(context.Request["Status"]))
                    {
                        model.Status = Convert.ToByte(context.Request["Status"]);
                        bll.Update(model);
                    }                    
                    string memberStr = RequestHelper.string_transfer(context.Request, "MemberStr");
                    string MemberEdit = RequestHelper.string_transfer(context.Request, "MemberEdit");
                    string add_Path = RequestHelper.string_transfer(context.Request, "Add_Path");
                    string edit_PathId = RequestHelper.string_transfer(context.Request, "Edit_PathId");
                    List<TPM_RewardUserInfo> editlist = new List<TPM_RewardUserInfo>();
                    if (!string.IsNullOrEmpty(MemberEdit))
                    {
                        editlist = JsonConvert.DeserializeObject<List<TPM_RewardUserInfo>>(MemberEdit);
                    }
                    jsonModel = bll.Edit_AcheiveMember(editlist, Id);
                    if (!string.IsNullOrEmpty(memberStr))
                    {
                        List<TPM_RewardUserInfo> memlist = JsonConvert.DeserializeObject<List<TPM_RewardUserInfo>>(memberStr);
                        foreach (TPM_RewardUserInfo item in memlist)
                        {
                            item.RIId = Id;
                            jsonModel = new TPM_RewardUserInfoService().Add(item); //数据库插入                           
                        }
                    }
                    if (!string.IsNullOrEmpty(add_Path) || !string.IsNullOrEmpty(edit_PathId))
                    {
                        List<Sys_Document> pathlist = new List<Sys_Document>();
                        if (!string.IsNullOrEmpty(add_Path))
                        {
                            pathlist = JsonConvert.DeserializeObject<List<Sys_Document>>(add_Path);
                        }
                        new Sys_DocumentService().OperDocument(pathlist, edit_PathId, Id);
                    }
                    string EditReason=RequestHelper.string_transfer(context.Request, "EditReason");
                    string CreateUID = RequestHelper.string_transfer(context.Request, "CreateUID");                    
                    string Reason_Path = RequestHelper.string_transfer(context.Request, "Reason_Path");
                    string ResonRecord = RequestHelper.string_transfer(context.Request, "ResonRecord");
                    if (!string.IsNullOrEmpty(EditReason)) //修改原因
                    {
                        JsonModel reaJsonModel=new TPM_ModifyReasonService().Add(new TPM_ModifyReason() {  EditReason=EditReason,CreateUID= CreateUID });
                        if (reaJsonModel.errNum == 0)
                        {
                            int reasonid = Convert.ToInt32(reaJsonModel.retData);
                            if (!string.IsNullOrEmpty(Reason_Path)) //管理员修改时，上传的附件
                            {
                                List<Sys_Document> pathlist = JsonConvert.DeserializeObject<List<Sys_Document>>(Reason_Path);
                                new Sys_DocumentService().OperDocument(pathlist, "", reasonid);
                            }
                            if (!string.IsNullOrEmpty(ResonRecord)) //分数分配历史
                            {
                                List<TPM_ModifyRecord> reclist = JsonConvert.DeserializeObject<List<TPM_ModifyRecord>>(ResonRecord);
                                bll.Add_ModifyRecord(reasonid, reclist);
                            }
                        }                        
                    }
                }
            }
            catch (Exception ex)
            {
                jsonModel = new JsonModel()
                {
                    errNum = 400,
                    errMsg = ex.Message,
                    retData = ""
                };
                LogService.WriteErrorLog(ex.Message);
            }
        }
        #endregion
        #endregion

        #region 教材相关方法  
        private void GetTPM_BookStory(HttpContext context)
        {
            try
            {
                bool IsPage = true;
                if (context.Request["IsPage"].SafeToString() != "" && context.Request["IsPage"] != "undefined")
                {
                    IsPage = Convert.ToBoolean(context.Request["IsPage"]);
                }
                Hashtable ht = new Hashtable();
                ht.Add("PageIndex", context.Request["PageIndex"].SafeToString());
                ht.Add("PageSize", context.Request["PageSize"].SafeToString());
                ht.Add("Id", context.Request["Id"].SafeToString());
                ht.Add("BookType", context.Request["BookType"].SafeToString());
                ht.Add("IsPlanBook", context.Request["IsPlanBook"].SafeToString());                
                ht.Add("Status", context.Request["Status"].SafeToString());
                ht.Add("Name", context.Request["Name"].SafeToString());
                ht.Add("Author_SelfNo", context.Request["Author_SelfNo"].SafeToString());
                ht.Add("AuthorNo", context.Request["AuthorNo"].SafeToString());
                ht.Add("Major_ID", context.Request["Major_ID"].SafeToString());
                ht.Add("LoginMajor_ID", context.Request["LoginMajor_ID"].SafeToString());                
                ht.Add("IdentifyCol", context.Request["IdentifyCol"].SafeToString());//标识列 立项教材（0未出版；1已出版）;已出版教材（立项教材id）
                jsonModel = bookbll.GetPage(ht, IsPage);
            }
            catch (Exception ex)
            {
                jsonModel = new JsonModel()
                {
                    errNum = 400,
                    errMsg = ex.Message,
                    retData = ""
                };
                LogService.WriteErrorLog(ex.Message);
            }
        }
        private void AddTPM_BookStory(HttpContext context)
        {
            TPM_BookStory model = null;
            int Id = RequestHelper.int_transfer(context.Request, "Id");
            string MEditor = context.Request["MEditor"].SafeToString();
            bool isadd = Id == 0;
            if (Id == 0)
            {
                model = new TPM_BookStory();
                model.CreateUID= RequestHelper.string_transfer(context.Request, "CreateUID");
            }
            else
            {
                model = bookbll.GetEntityById(Id).retData as TPM_BookStory;
                model.EditUID = RequestHelper.string_transfer(context.Request, "CreateUID");
            }
            model.Name = context.Request["Name"].SafeToString();
            model.BookType = Convert.ToByte(context.Request["BookType"]);
            model.EditionNo = RequestHelper.int_transfer(context.Request, "EditionNo");
            model.FileInfo = context.Request["FileInfo"].SafeToString();
            model.ISBN = context.Request["ISBN"].SafeToString(); 
            if (model.BookType == 2&&IsExistSameISBN(model.ISBN,Id) >0)
            {
                jsonModel = JsonModel.get_jsonmodel(-1, "已存在相同的书号！", "");
                return;
            }            
            model.IsOneVolum = Convert.ToByte(context.Request["IsOneVolum"]);
            model.IsPlanBook = Convert.ToByte(context.Request["PlanBook"]);
            model.ProjectType = Convert.ToByte(context.Request["ProjectType"]??"0");
            model.MainISBN = context.Request["MainISBN"].SafeToString();
            model.MEditor = MEditor;
            model.MEditorDepart = context.Request["MEditorDepart"].SafeToString();
            model.Publisher = context.Request["Publisher"].SafeToString();
            model.PublisthTime = RequestHelper.DateTime_transfer(context.Request["PublisthTime"]);
            model.SeriesBookName = context.Request["SeriesBookName"].SafeToString();
            model.SeriesBookNum = RequestHelper.int_transfer(context.Request, "SeriesBookNum");
            model.UseObj = context.Request["UseObj"].SafeToString();
            model.IsOneAuthor = Convert.ToByte(context.Request["OneAuthor"]);
            model.Status = Convert.ToInt32(context.Request["Status"]);
            int isTransfer = 0;
            TPM_BookStory pro_Model = new TPM_BookStory();
            if (!string.IsNullOrEmpty(context.Request["SelBook"]))
            {
                int bookid= RequestHelper.int_transfer(context.Request, "SelBook");
                model.IdentifyCol = bookid;
                if (model.Status == 3)
                {
                    pro_Model = bookbll.GetEntityById(Convert.ToInt32(model.IdentifyCol)).retData as TPM_BookStory;
                    if (pro_Model.IdentifyCol == 1)//判断转出版的立项教材是不是已经出版了
                    {
                        jsonModel = JsonModel.get_jsonmodel(-2, "该立项教材已转出版！", "");
                        return;
                    }
                    else
                    {
                        pro_Model.IdentifyCol = 1;
                        isTransfer = 1;                        
                    }
                }                             
            }
            if (Id == 0)
            {
                jsonModel = bookbll.Add(model);
                int returnId= Id = (int)jsonModel.retData;                
            }
            else
            {
                jsonModel = bookbll.Update(model);
            }
            if (jsonModel.errNum == 0)
            {
                if (isTransfer == 1)
                {
                    bookbll.Update(pro_Model);
                }
                string add_Path = RequestHelper.string_transfer(context.Request, "Add_Path");
                string edit_PathId = RequestHelper.string_transfer(context.Request, "Edit_PathId");
                if (!string.IsNullOrEmpty(add_Path) || !string.IsNullOrEmpty(edit_PathId))
                {
                    List<Sys_Document> pathlist = new List<Sys_Document>();
                    if (!string.IsNullOrEmpty(add_Path))
                    {
                        pathlist = JsonConvert.DeserializeObject<List<Sys_Document>>(add_Path);
                    }
                    new Sys_DocumentService().OperDocument(pathlist, edit_PathId, Id);
                }
                string memberStr = RequestHelper.string_transfer(context.Request, "MemberStr");
                string MemberEdit = RequestHelper.string_transfer(context.Request, "MemberEdit");
                if (!isadd)
                {
                    List<TPM_RewardUserInfo> editlist = new List<TPM_RewardUserInfo>();
                    if (!string.IsNullOrEmpty(MemberEdit))
                    {
                        editlist = JsonConvert.DeserializeObject<List<TPM_RewardUserInfo>>(MemberEdit);
                    }
                    jsonModel = bll.Edit_RewardUserInfo(editlist, Id);
                }
                if (!string.IsNullOrEmpty(memberStr))
                {
                    List<TPM_RewardUserInfo> memlist = JsonConvert.DeserializeObject<List<TPM_RewardUserInfo>>(memberStr);
                    foreach (TPM_RewardUserInfo item in memlist)
                    {
                        item.BookId = Id;
                        jsonModel = new TPM_RewardUserInfoService().Add(item); //数据库插入                           
                    }
                }
            }
        }
        private int IsExistSameISBN(string isbn, int id = 0)
        {
            string sql = "select count(1) from TPM_BookStory where IsDelete=0 and Status=3 and ISBN='" + isbn + "'";
            if (id != 0)
            {
                sql += " and Id!="+id;
            }
            return Convert.ToInt32(SQLHelp.ExecuteScalar(sql, CommandType.Text, null));
        }        
        private void CheckTPM_BookStory(HttpContext context)
        {
            int Id = RequestHelper.int_transfer(context.Request, "Id");
            TPM_BookStory model = bookbll.GetEntityById(Id).retData as TPM_BookStory;            
            model.Status = Convert.ToInt32(context.Request["Status"]);
            if (model.Status==3&&model.BookType == 2)
            {
                if(IsExistSameISBN(model.ISBN) > 0)
                {
                    jsonModel = JsonModel.get_jsonmodel(-1, "已存在相同的书号！", "");
                    return;
                }
                if (model.IdentifyCol>0) //判断转出版的立项教材是不是已经出版了
                {
                    TPM_BookStory pro_Model = bookbll.GetEntityById(Convert.ToInt32(model.IdentifyCol)).retData as TPM_BookStory;
                    if (pro_Model.IdentifyCol == 1)
                    {
                        jsonModel = JsonModel.get_jsonmodel(-2, "相关的立项教材已转出版！", "");
                        return;
                    }
                    else {
                        pro_Model.IdentifyCol = 1;
                        bookbll.Update(pro_Model);
                    }
                }
            }
            jsonModel = bookbll.Update(model);
        }
        private void Del_BookStory(HttpContext context)
        {
            int Id = RequestHelper.int_transfer(context.Request, "ItemId");            
            jsonModel = bookbll.DeleteFalse(Id);
        }
        #endregion

        #region 业绩分配用户信息
        private void GetTPM_UserInfo(HttpContext context)
        {
            try
            {
                bool IsPage = true;
                if (context.Request["IsPage"].SafeToString() != "" && context.Request["IsPage"] != "undefined")
                {
                    IsPage = Convert.ToBoolean(context.Request["IsPage"]);
                }
                Hashtable ht = new Hashtable();
                ht.Add("IsStatistic", context.Request["IsStatistic"]??"0"); //0 不是统计(默认); 1统计;2统计详情
                ht.Add("PageIndex", context.Request["PageIndex"].SafeToString());
                ht.Add("PageSize", context.Request["PageSize"].SafeToString());
                ht.Add("Id", context.Request["Id"].SafeToString());
                ht.Add("Name", context.Request["Name"].SafeToString());
                ht.Add("RIId", context.Request["RIId"].SafeToString());
                ht.Add("BookId", context.Request["BookId"].SafeToString());
                ht.Add("DepartMent", context.Request["DepartMent"].SafeToString());
                ht.Add("BeginTime", context.Request["BeginTime"].SafeToString());
                ht.Add("EndTime", context.Request["EndTime"].SafeToString());
                ht.Add("UserNos", context.Request["UserNos"].SafeToString());
                ht.Add("Static_RIId", context.Request["Static_RIId"]??"");
                ht.Add("Status_Com", context.Request["Status_Com"]);
                jsonModel = userbll.GetPage(ht, IsPage);
                if (ht["IsStatistic"].ToString() == "1")
                {
                    ht.Add("AllScore",1);
                    DataTable scoreDt= userbll.GetData(ht, false);
                    jsonModel.errMsg = scoreDt.Rows[0]["AllScore"].ToString();
                }               
            }
            catch (Exception ex)
            {
                jsonModel = new JsonModel()
                {
                    errNum = 400,
                    errMsg = ex.Message,
                    retData = ""
                };
                LogService.WriteErrorLog(ex.Message);
            }
        }
        private void AddTPM_UserInfo(HttpContext context)
        {
            TPM_RewardUserInfo model = null;
            string Id = context.Request["Id"].SafeToString();
            int Award = RequestHelper.int_transfer(context.Request, "Award");
            int Score = RequestHelper.int_transfer(context.Request, "Score");
            int Sort = RequestHelper.int_transfer(context.Request, "Sort");
            Byte ULevel = Convert.ToByte(context.Request["ULevel"]); ;
            int WordNum = RequestHelper.int_transfer(context.Request, "WordNum");

            if (Id == "")
            {
                model = new TPM_RewardUserInfo();
                model.Id = 0;
                model.UserNo = context.Request["UserNo"].SafeToString();
                model.CreateUID = context.Request["CreateUID"].SafeToString();
                model.RIId = RequestHelper.int_transfer(context.Request, "RIId");
                model.BookId = RequestHelper.int_transfer(context.Request, "BookId");
                model.DepartMent = context.Request["DepartMent"].SafeToString();
                model.Award = Award;
                model.Score = Score;
                model.Sort = Sort;
                model.ULevel = ULevel;
                model.WordNum = WordNum;
            }
            else
            {
                model = userbll.GetEntityById(Convert.ToInt32(Id)).retData as TPM_RewardUserInfo;
                if (Award > 0)
                {
                    model.Award = Award;
                }
                if (Score > 0)
                {
                    model.Score = Score;
                }
                if (Sort > 0)
                {
                    model.Sort = Sort;
                }
                if (ULevel > 0)
                {
                    model.ULevel = ULevel;
                }
                if (WordNum > 0)
                {
                    model.WordNum = WordNum;
                }
            }
            jsonModel = userbll.TPM_RewardUserAdd(model);
        }
        private void DelTPM_UserInfo(HttpContext context)
        {

            string[] ids = context.Request["Id"].Trim(',').Split(',');
            jsonModel = userbll.DeleteBatch(ids);
        }
        #endregion

        #region 排名相关方法        
        private void GetRank(HttpContext context)
        {
            Hashtable ht = new Hashtable();
            ht.Add("TableName", "(select trank.*,(select count(1) from TPM_AcheiveRewardInfo where IsDelete=0 and sort=trank.Id) as UseCount from TMP_RewardRank trank)");
            ht.Add("Order", "RankNum desc");
            jsonModel = rankbll.GetPage(ht, false, " and RId=" + context.Request["RId"]);
        }
        private void GenerateRank(HttpContext context)
        {
            string RId = context.Request["RId"].SafeToString();
            string RankNum = context.Request["RankNum"].SafeToString();
            string HighScore = context.Request["HighScore"].SafeToString();
            string OneRank = context.Request["OneRank"].SafeToString();
            string OneScore = context.Request["OneScore"].SafeToString();
            string TwoRank = context.Request["TwoRank"].SafeToString();
            string TwoScore = context.Request["TwoScore"].SafeToString();
            string CreateUID = context.Request["CreateUID"].SafeToString();
            jsonModel = rankbll.GenerateRank(RId, RankNum, HighScore, OneRank, OneScore, TwoRank, TwoScore, CreateUID);
        }
        private void OperRank(HttpContext context)
        {
            int RId = Convert.ToInt32(context.Request["RId"].SafeToString());
            string CreateUID = context.Request["CreateUID"].SafeToString();
            string addStr = context.Request["AddList"], editStr = context.Request["EditList"];
            if (!string.IsNullOrEmpty(addStr))
            {
                List<TMP_RewardRank> add_List = JsonConvert.DeserializeObject<List<TMP_RewardRank>>(addStr);
                foreach (TMP_RewardRank item in add_List)
                {
                    item.RId = RId;
                    item.CreateUID = CreateUID;
                    item.CreateTime = DateTime.Now;
                    jsonModel = rankbll.Add(item);
                }
            }
            if (!string.IsNullOrEmpty(editStr))
            {
                List<TMP_RewardRank> edit_List = JsonConvert.DeserializeObject<List<TMP_RewardRank>>(editStr);
                jsonModel = rankbll.Edit_Rank(edit_List);
            }
        }
        private void DelRank(HttpContext context)
        {
            int Id = Convert.ToInt32(context.Request["Id"]);
            //是否已经引用
            int useCount = Convert.ToInt32(SQLHelp.ExecuteScalar("select count(1) from TPM_AcheiveRewardInfo where IsDelete=0 and sort='" + Id + "'", CommandType.Text, null));
            if (useCount > 0)
            {
                jsonModel = JsonModel.get_jsonmodel(-1, "该排名已经被使用！", "");
                return;
            }
            jsonModel = rankbll.Delete(Id);
        }
        #endregion

        #region 文件信息
        private void Get_Sys_Document(HttpContext context)
        {
            try
            {
                bool IsPage = true;
                if (context.Request["IsPage"].SafeToString() != "" && context.Request["IsPage"] != "undefined")
                {
                    IsPage = Convert.ToBoolean(context.Request["IsPage"]);
                }
                Hashtable ht = new Hashtable();
                ht.Add("PageIndex", context.Request["PageIndex"].SafeToString());
                ht.Add("PageSize", context.Request["PageSize"].SafeToString());              
                ht.Add("Id", context.Request["Id"].SafeToString());
                ht.Add("Type", context.Request["Type"].SafeToString());
                ht.Add("RelationId", context.Request["RelationId"].SafeToString());
                jsonModel = new Sys_DocumentService().GetPage(ht, IsPage);
            }
            catch (Exception ex)
            {
                jsonModel = new JsonModel()
                {
                    errNum = 400,
                    errMsg = ex.Message,
                    retData = ""
                };
                LogService.WriteErrorLog(ex.Message);
            }
        }
        #endregion

        #region 追加奖金
        private void Get_RewardBatchData(HttpContext context)
        {
            try
            {
                bool IsPage = true;
                if (context.Request["IsPage"].SafeToString() != "" && context.Request["IsPage"] != "undefined")
                {
                    IsPage = Convert.ToBoolean(context.Request["IsPage"]);
                }
                Hashtable ht = new Hashtable();
                ht.Add("PageIndex", context.Request["PageIndex"].SafeToString());
                ht.Add("PageSize", context.Request["PageSize"].SafeToString());
                ht.Add("IsOnlyBase", context.Request["IsOnlyBase"]??"1");
                ht.Add("Reward_Id", context.Request["Reward_Id"].SafeToString());
                ht.Add("AchieveId", context.Request["AchieveId"].SafeToString());
                ht.Add("Id", context.Request["Id"].SafeToString());
                ht.Add("AuditStatus", context.Request["AuditStatus"].SafeToString()); 
                jsonModel = rbatchbll.GetPage(ht, IsPage);
            }
            catch (Exception ex)
            {
                jsonModel = new JsonModel()
                {
                    errNum = 400,
                    errMsg = ex.Message,
                    retData = ""
                };
                LogService.WriteErrorLog(ex.Message);
            }
        }
        #endregion

        #region 获取奖金分配信息
        private void Get_AllotReward(HttpContext context)
        {
            try
            {
                bool IsPage = true;
                if (context.Request["IsPage"].SafeToString() != "" && context.Request["IsPage"] != "undefined")
                {
                    IsPage = Convert.ToBoolean(context.Request["IsPage"]);
                }
                Hashtable ht = new Hashtable();
                ht.Add("PageIndex", context.Request["PageIndex"].SafeToString());
                ht.Add("PageSize", context.Request["PageSize"].SafeToString());             
                ht.Add("RewardBatch_Id", context.Request["RewardBatch_Id"].SafeToString());
                ht.Add("AchieveId", context.Request["AchieveId"].SafeToString());
                ht.Add("No_Status", context.Request["No_Status"].SafeToString());
                ht.Add("Id", context.Request["Id"].SafeToString());
                jsonModel = new TPM_AllotRewardService().GetPage(ht, IsPage);
            }
            catch (Exception ex)
            {
                jsonModel = new JsonModel()
                {
                    errNum = 400,
                    errMsg = ex.Message,
                    retData = ""
                };
                LogService.WriteErrorLog(ex.Message);
            }
        }
        #endregion

        #region 保存奖金分配信息
        private void Oper_AuditAllotReward(HttpContext context)
        {
            try
            {
                TPM_AuditReward audModel = new TPM_AuditReward();
                audModel.Acheive_Id= RequestHelper.int_transfer(context.Request, "Acheive_Id");
                audModel.RewardBatch_Id = RequestHelper.int_transfer(context.Request, "RewardBatch_Id");
                audModel.Status =Convert.ToByte(context.Request["Status"]);
                audModel.CreateUID = RequestHelper.string_transfer(context.Request, "CreateUID");                
                string allotUser = RequestHelper.string_transfer(context.Request, "AllotUser");
                List<TPM_AllotReward> allotlist = new List<TPM_AllotReward>();
                if (!string.IsNullOrEmpty(allotUser))
                {
                    allotlist = JsonConvert.DeserializeObject<List<TPM_AllotReward>>(allotUser);                    
                }
                jsonModel = bll.Oper_AuditAllotReward(audModel, allotlist);
                if (jsonModel.errNum == 0)
                {
                    bll.Edit_AchieveStatus(Convert.ToInt32(audModel.Acheive_Id),10);
                    string add_Path = RequestHelper.string_transfer(context.Request, "Add_Path");
                    string edit_PathId = RequestHelper.string_transfer(context.Request, "Edit_PathId");
                    if (!string.IsNullOrEmpty(add_Path) || !string.IsNullOrEmpty(edit_PathId))
                    {
                        List<Sys_Document> pathlist = new List<Sys_Document>();
                        if (!string.IsNullOrEmpty(add_Path))
                        {
                            pathlist = JsonConvert.DeserializeObject<List<Sys_Document>>(add_Path);
                        }
                        new Sys_DocumentService().OperDocument(pathlist, edit_PathId,Convert.ToInt32(jsonModel.retData));
                    }
                }                
            }
            catch (Exception ex)
            {
                jsonModel = new JsonModel()
                {
                    errNum = 400,
                    errMsg = ex.Message,
                    retData = ""
                };
                LogService.WriteErrorLog(ex.Message);
            }
        }
        #endregion

        #region 管理员修改审核通过的奖金分配信息
        private void Admin_EditAllotReward(HttpContext context)
        {
            try
            { 
                string allotUser = RequestHelper.string_transfer(context.Request, "AllotUser");
                string EditReason = RequestHelper.string_transfer(context.Request, "EditReason");
                string CreateUID = RequestHelper.string_transfer(context.Request, "CreateUID");
                string Reason_Path = RequestHelper.string_transfer(context.Request, "Reason_Path");
                string ResonRecord = RequestHelper.string_transfer(context.Request, "ResonRecord");
                List<TPM_AllotReward> allotlist = new List<TPM_AllotReward>();
                if (!string.IsNullOrEmpty(allotUser))
                {
                    allotlist = JsonConvert.DeserializeObject<List<TPM_AllotReward>>(allotUser);
                }
                jsonModel = bll.Admin_EditAllotReward(allotlist);
                if (jsonModel.errNum == 0&&!string.IsNullOrEmpty(EditReason))
                {
                    JsonModel reaJsonModel = new TPM_ModifyReasonService().Add(new TPM_ModifyReason() { EditReason = EditReason, CreateUID = CreateUID });
                    if (reaJsonModel.errNum == 0)
                    {
                        int reasonid = Convert.ToInt32(reaJsonModel.retData);
                        if (!string.IsNullOrEmpty(Reason_Path)) //管理员修改时，上传的附件
                        {
                            List<Sys_Document> pathlist = JsonConvert.DeserializeObject<List<Sys_Document>>(Reason_Path);
                            new Sys_DocumentService().OperDocument(pathlist, "", reasonid);
                        }
                        if (!string.IsNullOrEmpty(ResonRecord)) //奖金分配历史
                        {
                            List<TPM_ModifyRecord> reclist = JsonConvert.DeserializeObject<List<TPM_ModifyRecord>>(ResonRecord);
                            bll.Add_ModifyRecord(reasonid, reclist);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                jsonModel = new JsonModel()
                {
                    errNum = 400,
                    errMsg = ex.Message,
                    retData = ""
                };
                LogService.WriteErrorLog(ex.Message);
            }
        }
        #endregion

        #region 奖金分配审核
        private void Check_AuditReward(HttpContext context)
        {
            int achieveId = RequestHelper.int_transfer(context.Request, "AchieveId");
            int Id = RequestHelper.int_transfer(context.Request, "Id");
            TPM_AuditReward model = rauditbll.GetEntityById(Id).retData as TPM_AuditReward;
            int oldstatus = Convert.ToInt32(model.Status);
            model.Status = Convert.ToByte(context.Request["Status"]);
            jsonModel= rauditbll.Update(model);
            string hisrecord = RequestHelper.string_transfer(context.Request, "HisRecord");
            if (oldstatus != 3 && model.Status == 3 && !string.IsNullOrEmpty(hisrecord))
            {
                List<TPM_ModifyRecord> reclist = JsonConvert.DeserializeObject<List<TPM_ModifyRecord>>(hisrecord);
                foreach (TPM_ModifyRecord item in reclist)
                {
                    jsonModel = mrecordbll.Add(item);
                }
            }
        }
        #endregion

        #region 分配历史记录
        private void Get_ModifyRecordData(HttpContext context)
        {
            try
            {
                bool IsPage = true;
                if (context.Request["IsPage"].SafeToString() != "" && context.Request["IsPage"] != "undefined")
                {
                    IsPage = Convert.ToBoolean(context.Request["IsPage"]);
                }
                Hashtable ht = new Hashtable();
                ht.Add("PageIndex", context.Request["PageIndex"].SafeToString());
                ht.Add("PageSize", context.Request["PageSize"].SafeToString());
                ht.Add("Acheive_Id", context.Request["Acheive_Id"]);
                ht.Add("ModifyUID", context.Request["ModifyUID"].SafeToString());                
                ht.Add("Id", context.Request["Id"].SafeToString());
                ht.Add("Type", context.Request["Type"].SafeToString());
                ht.Add("RelationId", context.Request["RelationId"].SafeToString());
                jsonModel = mrecordbll.GetPage(ht, IsPage);
            }
            catch (Exception ex)
            {
                jsonModel = new JsonModel()
                {
                    errNum = 400,
                    errMsg = ex.Message,
                    retData = ""
                };
                LogService.WriteErrorLog(ex.Message);
            }
        }
        #endregion
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}