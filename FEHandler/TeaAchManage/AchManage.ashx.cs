using FEBLL;
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
    /// AchManage 的摘要说明
    /// </summary>
    public class AchManage : IHttpHandler
    {
        //业绩等级
        TPM_AcheiveLevelService AcheiveLevel_bll = new TPM_AcheiveLevelService();
        TPM_RewardEditionService RewardEdition_bll = new TPM_RewardEditionService();
        TPM_RewardLevelService RewardLevel_bll = new TPM_RewardLevelService();
        TPM_RewardInfoService RewardInfo_bll = new TPM_RewardInfoService();
        TPM_RewardBatchService RewardBatch_bll = new TPM_RewardBatchService();
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
                    /*业绩等级*/
                    case "GetAcheiveLevelData":
                        GetAcheiveLevelData(context);
                        break;
                    case "AddAcheiveLevelData":
                        AddAcheiveLevelData(context);
                        break;
                    case "DelAcheiveLevelData":
                        DelAcheiveLevelData(context);
                        break;
                    case "TPM_AcheiveLevelSort":
                        TPM_AcheiveLevelSort(context);
                        break;
                    case "ChangeAwardSwichStatus":
                        ChangeAwardSwichStatus(context);
                        break;
                    /*奖励项目版本*/
                    case "GetRewardEditionData":
                        GetRewardEditionData(context);
                        break;
                    case "AddRewardEditionData":
                        AddRewardEditionData(context);
                        break;
                    case "ChangeRewardEditionAllot":
                        ChangeRewardEditionAllot(context);
                        break;
                    case "Del_RewardEdition":
                        Del_RewardEdition(context);
                        break;
                    /*奖励项目等级*/
                    case "GetRewardLevelData":
                        GetRewardLevelData(context);
                        break;
                    case "AddRewardLevelData":
                        AddRewardLevelData(context);
                        break;
                    case "SortRewardLevelData":
                        SortRewardLevelData(context);
                        break;
                    /*奖项管理*/
                    case "GetRewardInfoData":
                        GetRewardInfoData(context);
                        break;
                    case "AddRewardInfoData":
                        AddRewardInfoData(context);
                        break;
                    case "SortRewardInfoData":
                        SortRewardInfoData(context);
                        break;
                    case "AddRewardDash":
                        AddRewardDash(context);
                        break;
                    /*奖金批次*/
                    case "Get_RewardBatchData":
                        Get_RewardBatchData(context);
                        break;
                    case "Add_RewardBatch":
                        Add_RewardBatch(context);
                        break;                        
                    case "Del_RewardBatch":
                        Del_RewardBatch(context);
                        break;
                    case "ChangeIsMoneyAllot":
                        ChangeIsMoneyAllot(context);
                        break;
                    case "Add_RewardBatchDetail":
                        Add_RewardBatchDetail(context);
                        break;
                    case "Del_RewardBatchDetail":
                        Del_RewardBatchDetail(context);
                        break;
                    case "BatchAllot_RewardBatchDetail":
                        BatchAllot_RewardBatchDetail(context);
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

        #region 业绩等级
        private void GetAcheiveLevelData(HttpContext context)
        {
            try
            {
                Hashtable ht = new Hashtable();
                ht.Add("TableName", " TPM_AcheiveLevel");
                ht.Add("PageIndex", context.Request["PageIndex"].SafeToString());
                ht.Add("PageSize", context.Request["PageSize"].SafeToString());
                ht.Add("Pid", context.Request["Pid"]);
                jsonModel = AcheiveLevel_bll.GetPage(ht, false);

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
        private void AddAcheiveLevelData(HttpContext context)
        {
            try
            {
                TPM_AcheiveLevel model = new TPM_AcheiveLevel();
                model.Name = context.Request["Name"];
                model.Pid = RequestHelper.int_transfer(context.Request, "Pid");
                model.Id = RequestHelper.int_transfer(context.Request, "Id");

                jsonModel = AcheiveLevel_bll.TPM_AcheiveLevelAdd(model);

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
        private void TPM_AcheiveLevelSort(HttpContext context)
        {
            try
            {
                int Id = RequestHelper.int_transfer(context.Request, "Id");
                string SortType = context.Request["SortType"];
                jsonModel = AcheiveLevel_bll.TPM_AcheiveLevelSort(Id, SortType);
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
        private void DelAcheiveLevelData(HttpContext context)
        {
            try
            {
                int itemid = Convert.ToInt32(context.Request["ItemId"]);
                jsonModel = AcheiveLevel_bll.Delete(itemid);
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
        /// <summary>
        /// 修改业绩金额分配状态
        /// </summary>
        /// <param name="context"></param>
        private void ChangeAwardSwichStatus(HttpContext context)
        {
            try
            {
                int Id = Convert.ToInt32(context.Request["Id"]);
                TPM_AcheiveLevel model = AcheiveLevel_bll.GetEntityById(Id).retData as TPM_AcheiveLevel;
                model.AwardSwich = Convert.ToByte(context.Request["AwardSwich"]);
                jsonModel = AcheiveLevel_bll.Update(model);
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

        #region 奖励项目版本
        private void GetRewardEditionData(HttpContext context)
        {
            try
            {
                int LID = RequestHelper.int_transfer(context.Request, "LID");
                bool Ispage = true;
                if (context.Request["IsPage"].SafeToString() != "")
                {
                    Ispage = Convert.ToBoolean(context.Request["IsPage"]);
                }
                Hashtable ht = new Hashtable();
                ht.Add("TableName", "TPM_RewardEdition");
                ht.Add("PageIndex", context.Request["PageIndex"].SafeToString());
                ht.Add("PageSize", context.Request["PageSize"].SafeToString());
                jsonModel = RewardEdition_bll.GetPage(ht, Ispage, " and IsDelete=0 and lid=" + LID);
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
        private void AddRewardEditionData(HttpContext context)
        {
            try
            {
                int Id = RequestHelper.int_transfer(context.Request, "Id");
                int lid = RequestHelper.int_transfer(context.Request, "LID");
                DateTime beginTime = RequestHelper.DateTime_transfer(context.Request, "BeginTime");
                DateTime endTime = RequestHelper.DateTime_transfer(context.Request, "EndTime");
                //" BeginTime>" +endTime + " or EndTime<"+beginTime 时间不重叠（not取非,获取不重叠）
                string id_str = Id == 0 ? "" : " and Id!=" + Id;
                Hashtable ht = new Hashtable();
                ht.Add("TableName", "TPM_RewardEdition");
                JsonModel edition_result = RewardEdition_bll.GetPage(ht, false, id_str + " and IsDelete=0 and lid=" + lid + " and not( convert(varchar(10),BeginTime,21)>'" + context.Request["endTime"] + "' or convert(varchar(10),EndTime,21)<'" + context.Request["beginTime"] + "')");
                if (edition_result.errNum == 0)
                {
                    jsonModel = JsonModel.get_jsonmodel(-1, "与其他版本时间交叉！", edition_result.retData);
                    return;
                }
                if (Id == 0)
                {
                    TPM_RewardEdition model = new TPM_RewardEdition();
                    model.Name = context.Request["Name"];
                    model.LID = lid;
                    model.BeginTime = beginTime;
                    model.EndTime = endTime;
                    jsonModel = RewardEdition_bll.Add(model);
                    Id = Convert.ToInt32(jsonModel.retData);
                }
                else
                {
                    //版本编辑时判断时间（时间、时间已在业绩中使用）
                    string definddates = SQLHelp.ExecuteScalar(@"select STUFF((select '、' + CAST(CONVERT(varchar(10),a.DefindDate,21) AS NVARCHAR(MAX)) from TPM_AcheiveRewardInfo a  
                                 left join TPM_RewardLevel lev on lev.Id = a.Lid
                                  where a.IsDelete = 0 and lev.EID =" + lid + " and(a.DefindDate < '" + context.Request["beginTime"] + "' or a.DefindDate > '" + context.Request["endTime"] + "') FOR xml path('')), 1, 1, '')", CommandType.Text, null).ToString();
                    if (!string.IsNullOrEmpty(definddates))
                    {
                        jsonModel = JsonModel.get_jsonmodel(-2, "日期" + definddates + "已在业绩中使用！", "");
                        return;
                    }
                    TPM_RewardEdition model = RewardEdition_bll.GetEntityById(Id).retData as TPM_RewardEdition;
                    model.Name = context.Request["Name"];
                    model.BeginTime = beginTime;
                    model.EndTime = endTime;
                    jsonModel = RewardEdition_bll.Update(model);
                }
                if (jsonModel.errNum == 0)
                {
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

        #region 修改项目版本金额分配状态
        private void ChangeRewardEditionAllot(HttpContext context)
        {
            try
            {
                int Id = Convert.ToInt32(context.Request["Id"]);
                TPM_RewardEdition model = RewardEdition_bll.GetEntityById(Id).retData as TPM_RewardEdition;
                model.IsMoneyAllot = Convert.ToByte(context.Request["IsMoneyAllot"]);
                jsonModel = RewardEdition_bll.Update(model);
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

        #region 删除项目版本
        private void Del_RewardEdition(HttpContext context)
        {
            try
            {
                int itemid = Convert.ToInt32(context.Request["ItemId"]);
                int useCount = Convert.ToInt32(SQLHelp.ExecuteScalar("select count(1) from TPM_AcheiveRewardInfo a left join TPM_RewardLevel lev on lev.Id = a.Lid where a.IsDelete = 0 and lev.EID =" + itemid, CommandType.Text, null));//是否已经引用
                if (useCount > 0)
                {
                    jsonModel = JsonModel.get_jsonmodel(-1, "该版本已经被使用！", "");
                    return;
                }
                jsonModel = RewardEdition_bll.DeleteFalse(itemid);
                if (jsonModel.errNum == 0)
                {
                    new Sys_DocumentService().DelDocByRelId(1, itemid);//删除版本相关文件
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

        #region 奖励项目等级
        private void GetRewardLevelData(HttpContext context)
        {
            try
            {
                bool IsPage = true;
                if (context.Request["IsPage"] != "" && context.Request["IsPage"] != "undefined")
                {
                    IsPage = Convert.ToBoolean(context.Request["IsPage"]);
                }
                int Id = RequestHelper.int_transfer(context.Request, "Id");

                int EID = RequestHelper.int_transfer(context.Request, "EID");
                int LID = RequestHelper.int_transfer(context.Request, "LID");
                string DefindDate = RequestHelper.string_transfer(context.Request, "DefindDate");
                Hashtable ht = new Hashtable();
                if (EID > 0)
                {
                    ht.Add("EID", EID);
                }
                if (LID > 0)
                {
                    ht.Add("LID", LID);
                }
                if (Id > 0)
                {
                    ht.Add("Id", Id);
                }
                if (!string.IsNullOrEmpty(DefindDate))
                {
                    ht.Add("DefindDate", Convert.ToDateTime(context.Request["DefindDate"]).ToString("yyyy-MM-dd"));
                }
                ht.Add("PageIndex", context.Request["PageIndex"].SafeToString());
                ht.Add("PageSize", context.Request["PageSize"].SafeToString());
                jsonModel = RewardLevel_bll.GetPage(ht, IsPage);

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
        private void AddRewardLevelData(HttpContext context)
        {
            try
            {
                int Id = RequestHelper.int_transfer(context.Request, "Id");
                if (Id == 0)
                {
                    TPM_RewardLevel model = new TPM_RewardLevel();
                    model.Name = context.Request["Name"];
                    model.EID = RequestHelper.int_transfer(context.Request, "EID");
                    model.Sort = RequestHelper.int_transfer(context.Request, "Sort");

                    jsonModel = RewardLevel_bll.Add(model);
                }
                else
                {
                    TPM_RewardLevel model = RewardLevel_bll.GetEntityById(Id).retData as TPM_RewardLevel;
                    string Name = context.Request["Name"].SafeToString();
                    int Sort = RequestHelper.int_transfer(context.Request, "Sort");
                    model.Name = Name;
                    model.Sort = Sort;

                    jsonModel = RewardLevel_bll.Update(model);

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
        private void SortRewardLevelData(HttpContext context)
        {
            try
            {
                int Id = RequestHelper.int_transfer(context.Request, "Id");
                string SortType = context.Request["SortType"];
                jsonModel = RewardLevel_bll.TPM_RewardLevelSort(Id, SortType);
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

        #region 奖项管理
        private void GetRewardInfoData(HttpContext context)
        {
            try
            {
                Hashtable ht = new Hashtable();
                int LID = RequestHelper.int_transfer(context.Request, "LID");
                if (LID > 0)
                {
                    ht.Add("LID", LID);
                }
                string Id = context.Request["Id"].SafeToString();
                if (Id != "0" && Id.Length > 0)
                {
                    ht.Add("Id", Id);
                }
                ht.Add("PageIndex", context.Request["PageIndex"].SafeToString());
                ht.Add("PageSize", context.Request["PageSize"].SafeToString());
                bool IsPage = true;
                if (context.Request["IsPage"] != "" && context.Request["IsPage"] != "undefined")
                {
                    IsPage = Convert.ToBoolean(context.Request["IsPage"]);
                }
                jsonModel = RewardInfo_bll.GetPage(ht, IsPage);
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
        private void AddRewardInfoData(HttpContext context)
        {
            try
            {
                int Id = RequestHelper.int_transfer(context.Request, "Id");
                if (Id == 0)
                {
                    TPM_RewardInfo model = new TPM_RewardInfo();
                    model.Name = context.Request["Name"];
                    model.LID = RequestHelper.int_transfer(context.Request, "LID");
                    model.Score = RequestHelper.decimal_transfer(context.Request, "Score");
                    model.ScoreType = Convert.ToByte(context.Request["ScoreType"]);
                    model.Sort = 1;
                    jsonModel = RewardInfo_bll.Add(model);
                }
                else
                {
                    int Batch_Id = RequestHelper.int_transfer(context.Request, "Batch_Id");
                    int useCount = RewardInfo_bll.GetReward_UseCount(Id);//奖项是否已经引用
                    if (useCount > 0)
                    {
                        jsonModel = JsonModel.get_jsonmodel(-1, "该奖项已经被使用！", "");
                        return;
                    }
                    int score_Count = RewardInfo_bll.GetRewardScore_UseCount(Id);//奖项分数是否已经引用
                    if (score_Count > 0)
                    {
                        jsonModel = JsonModel.get_jsonmodel(-2, "该奖项分数已经被使用！", "");
                        return;
                    }
                    TPM_RewardInfo model = RewardInfo_bll.GetEntityById(Id).retData as TPM_RewardInfo;
                    model.Score = RequestHelper.decimal_transfer(context.Request, "Score");
                    model.Name = context.Request["Name"];
                    jsonModel = RewardInfo_bll.Update(model);
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

        private void SortRewardInfoData(HttpContext context)
        {
            try
            {
                int Id = RequestHelper.int_transfer(context.Request, "Id");
                string SortType = context.Request["SortType"];
                jsonModel = RewardInfo_bll.TPM_RewardInfoSort(Id, SortType);
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

        #region 奖金批次
        private void AddRewardDash(HttpContext context)
        {
            try
            {
                int Id = RequestHelper.int_transfer(context.Request, "Id");
                int Reward_Id = RequestHelper.int_transfer(context.Request["Reward_Id"]);
                decimal AddAward = RequestHelper.decimal_transfer(context.Request["AddAward"]);
                string AddBasis = RequestHelper.string_transfer(context.Request, "AddBasis");
                string CreateUID = RequestHelper.string_transfer(context.Request, "CreateUID");
                if (Id == 0)
                {
                    //TPM_RewardBatch r_batch = new TPM_RewardBatch();
                    //r_batch.Reward_Id = Reward_Id;                    
                    //if (!string.IsNullOrEmpty(context.Request["Rank_Id"]))
                    //{
                    //    r_batch.Rank_Id = Convert.ToInt32(context.Request["Rank_Id"]);
                    //}
                    //r_batch.Money = AddAward;
                    //r_batch.AddBasis = AddBasis;
                    //r_batch.CreateUID = CreateUID;
                    //jsonModel= RewardBatch_bll.Add(r_batch);
                }
                else
                {
                    //int useCount = RewardInfo_bll.GetRewardMoney_UseCount(Id);//是否已经引用
                    //if (useCount > 0)
                    //{
                    //    jsonModel = JsonModel.get_jsonmodel(-1, "该奖金已经被使用！", "");
                    //    return;
                    //}
                    //TPM_RewardBatch model = RewardBatch_bll.GetEntityById(Id).retData as TPM_RewardBatch;                   
                    //model.Money = AddAward;
                    //model.AddBasis = AddBasis;
                    //model.EditUID = CreateUID;
                    //model.EditTime = DateTime.Now;
                    //jsonModel = RewardBatch_bll.Update(model);                    
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

        //奖金批次列表查询
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
                ht.Add("Id", context.Request["Id"].SafeToString());
                ht.Add("Year", context.Request["Year"].SafeToString());
                ht.Add("Name", context.Request["Name"].SafeToString());
                ht.Add("IsMoneyAllot", context.Request["IsMoneyAllot"].SafeToString());
                jsonModel = RewardBatch_bll.GetPage(ht, IsPage);
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

        //添加/编辑奖金批次
        private void Add_RewardBatch(HttpContext context)
        {
            TPM_RewardBatch model = null;
            int Id = RequestHelper.int_transfer(context.Request, "Id");
            decimal BatchMoney = Convert.ToDecimal(context.Request["BatchMoney"]);
            if (Id == 0)
            {
                model = new TPM_RewardBatch();
                model.CreateUID = RequestHelper.string_transfer(context.Request, "CreateUID");
            }
            else
            {
                decimal useMoney = RewardInfo_bll.GetRewardBatch_UseMoney(Id);//已分配金额
                if (useMoney > BatchMoney)
                {
                    jsonModel = JsonModel.get_jsonmodel(-2, "该奖金批次总金额小于已分配金额！", "");
                    return;
                }
                model = RewardBatch_bll.GetEntityById(Id).retData as TPM_RewardBatch;
                model.EditUID = RequestHelper.string_transfer(context.Request, "CreateUID");
            }
            string Year = context.Request["Year"].SafeToString();
            if (!string.IsNullOrEmpty(Year))
            {
                model.Year = Year.Replace("年", "");
            }
            else
                model.Year = "";
            model.Name = context.Request["Name"].SafeToString();
            model.BatchMoney = BatchMoney;
            if (Id == 0)
            {
                jsonModel = RewardBatch_bll.Add(model);
                Id = (int)jsonModel.retData;
            }
            else
            {
                jsonModel = RewardBatch_bll.Update(model);
            }
            if (jsonModel.errNum == 0)
            {
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
            }
        }
        //删除奖金批次
        private void Del_RewardBatch(HttpContext context)
        {
            try
            {
                int itemid = Convert.ToInt32(context.Request["ItemId"]);
                int useCount = RewardInfo_bll.GetRewardMoney_UseCount(itemid);//是否已经引用
                if (useCount > 0)
                {
                    jsonModel = JsonModel.get_jsonmodel(-1, "该奖金批次已经被使用！", "");
                    return;
                }
                jsonModel = RewardInfo_bll.Del_RewardBatch(itemid);
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

        //修改奖金批次金额分配状态
        private void ChangeIsMoneyAllot(HttpContext context)
        {
            try
            {
                int Id = Convert.ToInt32(context.Request["Id"]);
                TPM_RewardBatch model = RewardBatch_bll.GetEntityById(Id).retData as TPM_RewardBatch;
                model.IsMoneyAllot = Convert.ToByte(context.Request["IsMoneyAllot"]);
                jsonModel = RewardBatch_bll.Update(model);
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

        //添加奖金批次详情
        private void Add_RewardBatchDetail(HttpContext context)
        {
            try
            {
                int RewardBatch_Id = RequestHelper.int_transfer(context.Request, "RewardBatch_Id");
                string Acheive_Ids = RequestHelper.string_transfer(context.Request, "Acheive_Ids");
                string CreateUID = RequestHelper.string_transfer(context.Request, "CreateUID");
                jsonModel=RewardInfo_bll.Add_RewardBatchDetail(RewardBatch_Id, Acheive_Ids, CreateUID);
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

        //删除奖金批次详情
        private void Del_RewardBatchDetail(HttpContext context)
        {
            try
            {
                int itemid = Convert.ToInt32(context.Request["ItemId"]);                
                jsonModel = RewardInfo_bll.Del_RewardBatchDetail(itemid);
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

        //批量分配项目奖金
        private void BatchAllot_RewardBatchDetail(HttpContext context)
        {
            try
            {
                string BatchId = RequestHelper.string_transfer(context.Request, "BatchId");
                string BatchMoney = RequestHelper.string_transfer(context.Request, "BatchMoney");
                string LoginUID = RequestHelper.string_transfer(context.Request, "LoginUID");
                string LoginName = RequestHelper.string_transfer(context.Request, "LoginName");
                string ModifyRecord = RequestHelper.string_transfer(context.Request, "ModifyRecord");
                jsonModel = RewardInfo_bll.BatchAllot_RewardBatchDetail(BatchId, BatchMoney, LoginUID, LoginName, ModifyRecord);
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