using FEBLL;
using FEModel;
using FEModel.Entity;
using FEModel.Enum;
using FEUtility;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;

namespace FEHandler.Eva_Manage
{
    partial class Eva_ManageHandler
    {
        #region 获取定期评价

        /// <summary>
        ///获取定期评价【课堂评价】
        /// </summary>
        public void Get_Eva_RegularS(HttpContext context)
        {

            JsonModelNum jsm = new JsonModelNum();
            HttpRequest Request = context.Request;
            int intSuccess = (int)errNum.Success;
            int Type = RequestHelper.int_transfer(Request, "Type");
            int SectionId = RequestHelper.int_transfer(Request, "SectionId");
            int PageIndex = RequestHelper.int_transfer(Request, "PageIndex");
            int PageSize = RequestHelper.int_transfer(Request, "PageSize");
            try
            {
                //&& table.IsEnable == (int)IsEnable.Enable
                var regulist = (from regu in Constant.Eva_Regular_List
                                join section in Constant.StudySection_List on regu.Section_Id equals section.Id
                                join user in Constant.UserInfo_List on regu.CreateUID equals user.UniqueNo
                                join table in Constant.Eva_Table_List on regu.TableID equals table.Id
                                where regu.Type == Type 

                                select new Regu_S()
                                {
                                    SectionId = section.Id,
                                    DisPlayName = section.DisPlayName,
                                    CreateName = user.Name,
                                    ReguName = regu.Name,
                                    CreateUID = regu.CreateUID,
                                    StartTime = regu.StartTime,
                                    EndTime = regu.EndTime,
                                    CreateTime = regu.CreateTime,
                                    State = "",
                                    TableName = table.Name,
                                    Id = regu.Id,
                                    LookType = regu.LookType,
                                    TableID = regu.TableID
                                }).ToList();

                if (SectionId > 0)
                {
                    regulist = (from regu in regulist
                                where regu.SectionId == SectionId
                                select regu).ToList();

                }

                var query_last = (from an in regulist select an).Skip((PageIndex - 1) * PageSize).Take(PageSize).ToList();

                ReguState regustate = ReguState.进行中;
                foreach (var li in query_last)
                {

                    if (li.StartTime < DateTime.Now && (DateTime)li.EndTime >= DateTime.Now)
                    {
                        regustate = ReguState.进行中;
                    }
                    else if (li.StartTime > DateTime.Now)
                    {
                        regustate = ReguState.未开始;
                    }
                    else
                    {
                        regustate = ReguState.已结束;
                    }
                    li.State = Convert.ToString(regustate);
                    li.ReguState = (int)regustate;
                }

                //返回所有表格数据
                jsm = JsonModelNum.GetJsonModel_o(intSuccess, "success", query_last);
                jsm.PageIndex = PageIndex;
                jsm.PageSize = PageSize;
                jsm.PageCount = (int)Math.Ceiling((double)regulist.Count() / PageSize);
                jsm.RowCount = regulist.Count();

                jsonModel = JsonModel.get_jsonmodel(0, "success", regulist);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsm) + "}");
            }
        }

        /// <summary>
        ///获取定期评价
        /// </summary>
        public void Get_Eva_Regular(HttpContext context)
        {

            HttpRequest Request = context.Request;
            int Type = RequestHelper.int_transfer(Request, "Type");
            int SectionId = RequestHelper.int_transfer(Request, "SectionId");
            try
            {
                jsonModel = Get_Eva_RegularHelper(SectionId, Type);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        public static JsonModel Get_Eva_RegularHelper(int SectionId, int Type)
        {
            JsonModel model = new JsonModel();
            int intSuccess = (int)errNum.Success;
            try
            {
                var list = (from regu in Constant.Eva_Regular_List
                            where regu.Type == Type
                            join section in Constant.StudySection_List on regu.Section_Id equals section.Id
                            select new ReguModel()
                            {
                                SectionId = section.Id,
                                Value = regu.Name,
                                DisPlayName = section.DisPlayName,
                                Id = regu.Id,
                                Study_IsEnable = section.IsEnable,
                                EndTime = section.EndTime,
                                ReguStartTime = regu.StartTime,
                                ReguEndTime = regu.EndTime,
                            }).ToList();
                foreach (var item in Constant.StudySection_List)
                {
                    var li = list.FirstOrDefault(i => i.SectionId == item.Id);
                    if (li == null)
                    {
                        list.Add(new ReguModel()
                        {
                            SectionId = item.Id,
                            Value = "",
                            DisPlayName = item.DisPlayName,
                            Id = (int?)0,
                            Study_IsEnable = item.IsEnable,
                            EndTime = item.EndTime,
                            ReguStartTime = item.StartTime,
                            ReguEndTime = item.EndTime,
                        });
                    }
                }
                if (SectionId > 0)
                {
                    list = (from li in list where li.SectionId == SectionId select li).ToList();
                }
                ReguState regustate = ReguState.进行中;
                foreach (var li in list)
                {

                    if (li.ReguStartTime < DateTime.Now && (DateTime)li.ReguEndTime >= DateTime.Now)
                    {
                        regustate = ReguState.进行中;
                    }
                    else if (li.ReguStartTime > DateTime.Now)
                    {
                        regustate = ReguState.未开始;
                    }
                    else
                    {
                        regustate = ReguState.已结束;
                    }
                    li.ReguState = (int)regustate;
                }
                list = (from li in list orderby li.EndTime descending select li).ToList();
                //返回所有表格数据
                model = JsonModel.get_jsonmodel(intSuccess, "success", list);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return model;
        }

        /// <summary>
        /// 筛选
        /// </summary>
        /// <param name="context"></param>
        public void Get_Eva_Regular_Select(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            HttpRequest Request = context.Request;
            int SectionID = RequestHelper.int_transfer(Request, "SectionID");
            int Type = RequestHelper.int_transfer(Request, "Type");

            try
            {
                List<Eva_Regular> regulist = Constant.Eva_Regular_List;
                if (SectionID > 0)
                {
                    regulist = (from li in regulist where li.Section_Id == SectionID select li).ToList();
                }
                if (Type > 0)
                {
                    regulist = (from li in regulist where li.Type == Type select li).ToList();
                }

                var select = new
                {
                    RgList = (from li in regulist select new ReModel() { ReguId = li.Id, ReguName = li.Name }).Distinct(new ReModelComparer()).ToList(),
                };

                //返回所有表格数据
                jsonModel = JsonModelNum.GetJsonModel_o(intSuccess, "success", select);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        /// <summary>
        ///获取单独评价
        /// </summary>
        public void Get_Eva_RegularSingle(HttpContext context)
        {

            HttpRequest Request = context.Request;
            int Id = RequestHelper.int_transfer(Request, "Id");
            try
            {
                Eva_Regular regu = Constant.Eva_Regular_List.FirstOrDefault(i => i.Id == Id);
                if (regu != null)
                {
                    Eva_Table table = Constant.Eva_Table_List.FirstOrDefault(t => t.Id == regu.TableID);
                    StudySection section = Constant.StudySection_List.FirstOrDefault(s => s.Id == regu.Section_Id);
                    List<Major> departments = new List<Major>();
                    List<string> departmentids = new List<string>();
                    if (regu.LookType == (int)LookType.DepartmentType && regu.DepartmentIDs != "")
                    {
                        string[] departs = Split_Hepler.str_to_stringss(regu.DepartmentIDs);
                        departments = (from d in Constant.Major_List where departs.Contains(d.Id) select d).ToList();
                        departmentids = (from d in departments select d.Id).ToList();
                    }
                    var li = new
                    {
                        regu.StartTime,
                        regu.EndTime,
                        regu.Id,
                        regu.Name,
                        regu.LookType,
                        TableName = table != null ? table.Name : "",
                        section.DisPlayName,
                        SectionID = section.Id,
                        DepartmentList = departments,
                        regu.Type,
                        regu.TableID,
                        DepartmentIdList = departmentids,
                        regu.RoomID,
                    };
                    jsonModel = JsonModel.get_jsonmodel(0, "success", li);
                }
                else
                {
                    jsonModel = JsonModel.get_jsonmodel(3, "failed", "指定的定期评价不存在");
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        #endregion

        #region 获取课堂评价

        /// <summary>
        /// 获取定期评价列表数据
        /// </summary>
        public void Get_Eva_RegularData_Room(HttpContext context)
        {
            HttpRequest Request = context.Request;

            int SectionID = RequestHelper.int_transfer(Request, "SectionID");
            int ReguID = RequestHelper.int_transfer(Request, "ReguID");


            string Te = RequestHelper.string_transfer(Request, "Te");
            //string TeacherUID = RequestHelper.string_transfer(Request, "TeacherUID");
            string RP = RequestHelper.string_transfer(Request, "RP");
            string Gr = RequestHelper.string_transfer(Request, "Gr");
            string Key = RequestHelper.string_transfer(Request, "Key");

            int PageIndex = RequestHelper.int_transfer(Request, "PageIndex");
            int PageSize = RequestHelper.int_transfer(Request, "PageSize");
            try
            {
                jsonModel = Get_Eva_RegularData_Room_Helper(PageIndex, PageSize, SectionID, ReguID, Key, Te, RP, Gr);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        public static JsonModel Get_Eva_RegularData_Room_Helper(int PageIndex, int PageSize, int SectionID, int ReguID, string Key, string Te, string RP, string Gr)
        {
            int intSuccess = (int)errNum.Success;
            JsonModelNum jsm = new JsonModelNum();
            try
            {
                List<RegularDataRoomModel> list = (from regu in Constant.Eva_Regular_List
                                                   where regu.Type == (int)ReguType.RoomStudent
                                                   join section in Constant.StudySection_List on regu.Section_Id equals section.Id
                                                   join table in Constant.Eva_Table_List on regu.TableID equals table.Id into tables
                                                   from tb in tables.DefaultIfEmpty()
                                                   from room in Constant.CourseRoom_List
                                                   where room.StudySection_Id==regu.Section_Id&&((regu.DepartmentIDs.Contains(room.Major_Id)) || regu.DepartmentIDs == "")
                                                   orderby regu.EndTime descending
                                                   select new RegularDataRoomModel()
                                                   {
                                                       Num = 0,
                                                       SectionID = section.Id,
                                                       DisPlayName = section.DisPlayName,
                                                       ReguID = regu.Id,
                                                       ReguName = regu.Name,
                                                       RoomID = room.Id,
                                                       CourseID = room.Coures_Id,
                                                       CourseName = room.CouresName,
                                                       TeacherUID = room.TeacherUID,
                                                       TeacherName = room.TeacherName,
                                                       RoomDepartmentName = room.RoomDepartmentName,
                                                       GradeName = room.GradeName,
                                                       ClassName = room.ClassName,
                                                       StudentCount = room.StudentCount,
                                                       QuestionCount = 0,
                                                       QuestionAve = 0,
                                                       ScoreAve = 0,
                                                       TableID = regu.TableID,
                                                       StartTime = regu.StartTime,
                                                       EndTime = regu.EndTime,
                                                       IsOverTime = true,
                                                       IsScore =tb==null?false:(tb.IsScore == 0 ? true : false)
                                                   }).ToList();

                var questionList = (from q in Constant.Eva_QuestionAnswer_List
                                    where q.Eva_Role == (int)ReguType.RoomStudent
                                    select q).ToList();
                if (SectionID > 0)
                {
                    list = (from li in list where li.SectionID == SectionID select li).ToList();

                    questionList = (from q in questionList
                                    where q.SectionID == SectionID
                                    select q).ToList();
                }

                if (ReguID > 0)
                {
                    list = (from li in list where li.ReguID == ReguID select li).ToList();

                    questionList = (from q in questionList
                                    where q.ReguID == ReguID
                                    select q).ToList();
                }

                //if (TeacherUID != "")
                //{
                //    list = (from li in list where li.TeacherUID == TeacherUID select li).ToList();
                //}

                if (Te != "")
                {
                    list = (from li in list where li.TeacherUID == Te select li).ToList();
                }
                if (RP != "")
                {
                    list = (from li in list where li.RoomDepartmentName == RP select li).ToList();
                }
                if (Gr != "")
                {
                    list = (from li in list where li.GradeName == Gr select li).ToList();
                }

                if (Key != "")
                {
                    list = (from li in list where li.CourseName.Contains(Key) select li).ToList();
                }

                for (int i = 0; i < list.Count; i++)
                {
                    list[i].Num = i + 1;
                }

                var query_last = (from an in list select an).Skip((PageIndex - 1) * PageSize).Take(PageSize).ToList();


                foreach (var li in query_last)
                {
                    if (li.StartTime < DateTime.Now && (DateTime)li.EndTime >= DateTime.Now)
                    {
                        li.IsOverTime = false;
                    }

                    var chilist = (from q in questionList
                                   where q.SectionID==li.SectionID&&q.ReguID==li.ReguID&&q.TeacherUID == li.TeacherUID && q.CourseID == li.CourseID&&Convert.ToInt32(q.RoomID)==li.RoomID
                                   select q).ToList();
                    int que_count = chilist.Count;
                    if (que_count > 0)
                    {
                        decimal que_allScore = (decimal)chilist.Sum(i => i.Score);

                        li.QuestionCount = que_count;
                        li.QuestionAve = que_count > 0 ? (decimal)Math.Round(que_count / (decimal)li.StudentCount, 2) : 0;
                        //计算平均分
                        li.ScoreAve = que_count > 0 ? (decimal)Math.Round(que_allScore / (decimal)que_count, 2) : 0;
                    }

                }
                //返回所有表格数据
                jsm = JsonModelNum.GetJsonModel_o(intSuccess, "success", query_last);
                jsm.PageIndex = PageIndex;
                jsm.PageSize = PageSize;
                jsm.PageCount = (int)Math.Ceiling((double)list.Count() / PageSize);
                jsm.RowCount = list.Count();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return jsm;
        }

        /// <summary>
        /// 课堂扫码评价
        /// </summary>
        /// <param name="context"></param>
        public void Get_Eva_RegularData_Stu(HttpContext context)
        {
            HttpRequest Request = context.Request;

            int SectionID = RequestHelper.int_transfer(Request, "SectionID");
            string TeacherUID = RequestHelper.string_transfer(Request, "TeacherUID");
            string CourseID = RequestHelper.string_transfer(Request, "CourseID");
            string ClassID = RequestHelper.string_transfer(Request, "ClassID");

            int PageIndex = RequestHelper.int_transfer(Request, "PageIndex");
            int PageSize = RequestHelper.int_transfer(Request, "PageSize");
            try
            {
                jsonModel = Get_Eva_RegularData_Stu_Helper(PageIndex, PageSize, SectionID, TeacherUID, CourseID, ClassID);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        public static JsonModel Get_Eva_RegularData_Stu_Helper(int PageIndex, int PageSize, int SectionID, string TeacherUID, string CourseID, string ClassID)
        {
            int intSuccess = (int)errNum.Success;
            JsonModelNum jsm = new JsonModelNum();
            try
            {
                var roomlist = (from r in Constant.CourseRoom_List where r.TeacherUID == TeacherUID select r).ToList();
                List<RegularDataRoomModel> list = (from regu in Constant.Eva_Regular_List
                                                   where regu.Type == (int)ReguType.ClsStudent
                                                   join section in Constant.StudySection_List on regu.Section_Id equals section.Id
                                                   from room in roomlist
                                                   where Split_Hepler.str_to_ints(regu.RoomID).Contains((int)room.Id)
                                                   join table in Constant.Eva_Table_List on regu.TableID equals table.Id into tables
                                                   from tb in tables.DefaultIfEmpty()
                                                   orderby regu.EndTime descending
                                                   select new RegularDataRoomModel()
                                                   {
                                                       Num = 0,
                                                       Id = regu.Id,
                                                       SectionID = section.Id,
                                                       DisPlayName = section.DisPlayName,
                                                       ReguID = regu.Id,
                                                       ReguName = regu.Name,
                                                       RoomID = room.Id,
                                                       CourseID = room.Coures_Id,
                                                       CourseName = room.CouresName,
                                                       TeacherUID = room.TeacherUID,
                                                       TeacherName = room.TeacherName,
                                                       RoomDepartmentName = room.RoomDepartmentName,
                                                       GradeName = room.GradeName,
                                                       ClassID = room.ClassID,
                                                       ClassName = room.ClassName,
                                                       StudentCount = room.StudentCount,
                                                       QuestionCount = 0,
                                                       QuestionAve = 0,
                                                       ScoreAve = 0,
                                                       TableID = regu.TableID,
                                                       StartTime = regu.StartTime,
                                                       EndTime = regu.EndTime,
                                                       IsOverTime = true,
                                                       IsScore = tb.IsScore == 0 ? true : false,

                                                   }).ToList();

                var questionList = (from q in Constant.Eva_QuestionAnswer_List
                                    where q.Eva_Role == (int)ReguType.ClsStudent
                                    select q).ToList();
                if (SectionID > 0)
                {
                    list = (from li in list where li.SectionID == SectionID select li).ToList();

                    questionList = (from q in questionList
                                    where q.SectionID == SectionID
                                    select q).ToList();
                }

                if (!string.IsNullOrEmpty(CourseID))
                {
                    list = (from li in list where li.CourseID == CourseID select li).ToList();
                }

                if (!string.IsNullOrEmpty(ClassID))
                {
                    list = (from li in list where li.ClassID == ClassID select li).ToList();
                }

                for (int i = 0; i < list.Count; i++)
                {
                    list[i].Num = i + 1;
                }

                var query_last = (from an in list select an).Skip((PageIndex - 1) * PageSize).Take(PageSize).ToList();

                foreach (var li in query_last)
                {
                    ReguState regustate = ReguState.进行中;
                    if (li.StartTime < DateTime.Now && li.EndTime >= DateTime.Now)
                    {
                        regustate = ReguState.进行中;
                        li.IsOverTime = false;
                    }
                    else if (li.StartTime > DateTime.Now)
                    {
                        regustate = ReguState.未开始;
                    }
                    else
                    {
                        regustate = ReguState.已结束;
                    }
                    li.State = Convert.ToString(regustate);
                    li.StateType = (int)regustate;

                    var chilist = (from q in questionList
                                   where q.TeacherUID == li.TeacherUID && q.CourseID == li.CourseID && q.ReguID == li.ReguID
                                   select q).ToList();
                    int que_count = chilist.Count;
                    if (que_count > 0)
                    {
                        decimal que_allScore = (decimal)chilist.Sum(i => i.Score);

                        li.QuestionCount = que_count;
                        li.QuestionAve = que_count > 0 ? (decimal)Math.Round(que_count / (decimal)li.StudentCount, 2) : 0;
                        //计算平均分
                        li.ScoreAve = que_count > 0 ? (decimal)Math.Round(que_allScore / (decimal)que_count, 2) : 0;
                    }

                }
                //返回所有表格数据
                jsm = JsonModelNum.GetJsonModel_o(intSuccess, "success", query_last);
                jsm.PageIndex = PageIndex;
                jsm.PageSize = PageSize;
                jsm.PageCount = (int)Math.Ceiling((double)list.Count() / PageSize);
                jsm.RowCount = list.Count();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return jsm;
        }




        /// <summary>
        /// 获取课堂评价详情列表
        /// </summary>
        public void Get_Eva_RegularData_RoomDetailList(HttpContext context)
        {
            HttpRequest Request = context.Request;

            int SectionID = RequestHelper.int_transfer(Request, "SectionID");
            int ReguID = RequestHelper.int_transfer(Request, "ReguID");
            int TableID = RequestHelper.int_transfer(Request, "TableID");
            string TeacherUID = RequestHelper.string_transfer(Request, "TeacherUID");
            string CourseID = RequestHelper.string_transfer(Request, "CourseID");
            int Eva_Role = RequestHelper.int_transfer(Request, "Eva_Role");
            int State = RequestHelper.int_transfer(Request, "State");
            string RoomID = RequestHelper.string_transfer(Request, "RoomID");            
            try
            {
                jsonModel = Get_Eva_RegularData_RoomDetailList_Helper(SectionID, ReguID, TableID, TeacherUID, CourseID, RoomID,Eva_Role, State);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        /// <summary>
        /// 获取课堂评价详情列表辅助
        /// </summary>
        /// <param name="SectionID"></param>
        /// <param name="ReguID"></param>
        /// <param name="TableID"></param>
        /// <param name="TeacherUID"></param>
        /// <param name="CourseID"></param>
        /// <param name="Eva_Role"></param>
        /// <param name="State"></param>
        /// <returns></returns>
        public static JsonModel Get_Eva_RegularData_RoomDetailList_Helper(int SectionID, int ReguID, int TableID, string TeacherUID, string CourseID,string RoomID, int Eva_Role, int State)
        {
            int intSuccess = (int)errNum.Success;
            JsonModelNum jsm = new JsonModelNum();
            try
            {
                var list = (from q in Constant.Eva_QuestionAnswer_Detail_List
                            where q.SectionID == SectionID && q.ReguID == ReguID
                                && q.TableID == TableID && q.TeacherUID == TeacherUID && q.CourseID == CourseID &&q.RoomID==RoomID&& q.Eva_Role == Eva_Role
                            select q).ToList();
                var group = list.GroupBy(i => i.TableDetailID).ToList();

                AnsysRoomModel data = new AnsysRoomModel { Score_ModelList = new List<Score_Model>(), Multi_ModelList=new List<Score_Model>(), AnswerScore_ModelList = new List<AnswerScore_Model>(), HeaderModelList = new List<HeaderModel>() };
                Eva_QuestionAnswer_Detail detail = null;
                foreach (var itemlist in group)
                {
                    if (itemlist.Count() > 0)
                    {
                        detail = itemlist.ElementAt(0);
                        int QuestionType = (int)detail.QuestionType;
                        Question_Type Question_Type = (Question_Type)QuestionType;
                        switch (Question_Type)
                        {
                            case Question_Type.select:
                                data.Score_ModelList.Add(new Score_Model()
                                {
                                    TableDetialID = detail.TableDetailID,
                                    A = itemlist.Count(i => i.Answer == "OptionA"),
                                    B = itemlist.Count(i => i.Answer == "OptionB"),
                                    C = itemlist.Count(i => i.Answer == "OptionC"),
                                    D = itemlist.Count(i => i.Answer == "OptionD"),
                                    E = itemlist.Count(i => i.Answer == "OptionE"),
                                    F = itemlist.Count(i => i.Answer == "OptionF"),
                                });
                                break;
                            case Question_Type.multiselect:
                                data.Multi_ModelList.Add(new Score_Model()
                                {
                                    TableDetialID = detail.TableDetailID,
                                    A = itemlist.Count(i => i.Answer.Contains("OptionA")),
                                    B = itemlist.Count(i => i.Answer.Contains("OptionB")),
                                    C = itemlist.Count(i => i.Answer.Contains("OptionC")),
                                    D = itemlist.Count(i => i.Answer.Contains("OptionD")),
                                    E = itemlist.Count(i => i.Answer.Contains("OptionE")),
                                    F = itemlist.Count(i => i.Answer.Contains("OptionF")),
                                });
                                break;
                            case Question_Type.answer:

                                break;
                            case Question_Type.scoreSelect:
                                data.AnswerScore_ModelList.Add(new AnswerScore_Model()
                                  {
                                      TableDetialID = detail.TableDetailID,
                                      ScoreAve = itemlist.Count() > 0 ? (decimal)Math.Round((decimal)itemlist.Sum(i => i.Score) / (decimal)itemlist.Count(), 2) : 0,
                                  });

                                break;
                            default:
                                break;
                        }
                    }
                }
                if (detail != null)
                {
                    List<Eva_QuestionAnswer_Header> Headers = (from h in Constant.Eva_QuestionAnswer_Header_List where h.CustomCode != "" && h.CustomCode != null && h.QuestionID == detail.QuestionID select h).ToList();
                    data.HeaderModelList = (from h in Headers orderby h.Id select new HeaderModel() { CustomCode = h.CustomCode, Name = h.Name, Value = h.Value }).ToList();
                }

                //返回所有表格数据
                jsm = JsonModelNum.GetJsonModel_o(intSuccess, "success", data);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return jsm;
        }

        /// <summary>
        /// 获取课堂评价答题详情列表
        /// </summary>
        public void Get_Eva_RoomDetailAnswerList(HttpContext context)
        {
            HttpRequest Request = context.Request;

            int SectionID = RequestHelper.int_transfer(Request, "SectionID");
            int ReguID = RequestHelper.int_transfer(Request, "ReguID");
            int TableID = RequestHelper.int_transfer(Request, "TableID");
            int TableDetailID = RequestHelper.int_transfer(Request, "TableDetailID");
            string TeacherUID = RequestHelper.string_transfer(Request, "TeacherUID");
            string CourseID = RequestHelper.string_transfer(Request, "CourseID");
            string RoomID = RequestHelper.string_transfer(Request, "RoomID");
            int Eva_Role = RequestHelper.int_transfer(Request, "Eva_Role");
            int State = RequestHelper.int_transfer(Request, "State");

            int PageIndex = RequestHelper.int_transfer(Request, "PageIndex");
            int PageSize = RequestHelper.int_transfer(Request, "PageSize");
            try
            {
                jsonModel = Get_Eva_RoomDetailAnswerList_Helper(PageIndex, PageSize, SectionID, ReguID, TableID, TableDetailID, TeacherUID, CourseID, RoomID, Eva_Role, State);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SectionID"></param>
        /// <param name="ReguID"></param>
        /// <param name="TableID"></param>
        /// <param name="TeacherUID"></param>
        /// <param name="CourseID"></param>
        /// <param name="Eva_Role"></param>
        /// <param name="State"></param>
        /// <returns></returns>
        public static JsonModel Get_Eva_RoomDetailAnswerList_Helper(int PageIndex, int PageSize, int SectionID, int ReguID, int TableID, int TableDetailID, string TeacherUID, string CourseID,string RoomID,int Eva_Role, int State)
        {
            int intSuccess = (int)errNum.Success;
            JsonModelNum jsm = new JsonModelNum();
            try
            {
                var data = (from q in Constant.Eva_QuestionAnswer_Detail_List
                            where q.SectionID == SectionID && q.ReguID == ReguID && q.TableID == TableID && q.TableDetailID == TableDetailID && q.TeacherUID == TeacherUID
                                && q.CourseID == CourseID&&q.RoomID==RoomID && q.Eva_Role == Eva_Role
                            select new { q.Answer, q.CreateTime, AnswerName = q.IsRealName == (byte)IsRealNameType.yes ? q.AnswerName : "匿名" }
                             ).ToList();

                var query_last = (from an in data select an).Skip((PageIndex - 1) * PageSize).Take(PageSize).ToList();


                //返回所有表格数据
                jsm = JsonModelNum.GetJsonModel_o(intSuccess, "success", query_last);
                jsm.PageIndex = PageIndex;
                jsm.PageSize = PageSize;
                jsm.PageCount = (int)Math.Ceiling((double)data.Count() / PageSize);
                jsm.RowCount = data.Count();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return jsm;
        }

        /// <summary>
        /// 手机端首页
        /// </summary>
        /// <param name="context"></param>
        public void Get_Backlog(HttpContext context)
        {
            HttpRequest Request = context.Request;
            string StudentUID = RequestHelper.string_transfer(Request, "StudentUID");

            try
            {
                jsonModel = Get_Backlog_Helper(StudentUID);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        public static JsonModel Get_Backlog_Helper(string StudentUID)
        {
            int intSuccess = (int)errNum.Success;
            JsonModelNum jsm = new JsonModelNum();
            try
            {
                var list = (from li in Constant.Eva_QuestionAnswer_List
                            join regu in Constant.Eva_Regular_List on li.ReguID equals regu.Id
                            join section in Constant.StudySection_List on regu.Section_Id equals section.Id
                            where li.AnswerUID == StudentUID
                            select
                                new RegularDataRoomModel()
                                {
                                    Num = 0,
                                    SectionID = li.SectionID,
                                    DisPlayName = section.DisPlayName,
                                    ReguID = regu.Id,
                                    ReguName = regu.Name,
                                    Id = li.Id,
                                    CourseID = li.CourseID,
                                    CourseName = li.CourseName,
                                    TeacherUID = li.TeacherUID,
                                    TeacherName = li.TeacherName,
                                    TableID = regu.TableID,
                                    CreateTime = li.CreateTime,
                                }).ToList();

                //返回所有表格数据
                jsm = JsonModelNum.GetJsonModel_o(intSuccess, "success", list);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return jsm;
        }

        #endregion

        #region 获取定期评价列表数据【exp】

        /// <summary>
        /// 获取定期评价列表数据
        /// </summary>
        public void Get_Eva_RegularData(HttpContext context)
        {
            HttpRequest Request = context.Request;

            int SectionID = RequestHelper.int_transfer(Request, "SectionID");
            int ReguId = RequestHelper.int_transfer(Request, "ReguId");
            string Key = RequestHelper.string_transfer(Request, "Key");
            string SelectUID = RequestHelper.string_transfer(Request, "SelectUID");
            string Te = RequestHelper.string_transfer(Request, "Te");
            string DepartmentID = RequestHelper.string_transfer(Request, "DepartmentID");
            int ModelType = RequestHelper.int_transfer(Request, "ModelType");
            int FuncType = RequestHelper.int_transfer(Request, "FuncType");
            int IsSelfStart = RequestHelper.int_transfer(Request, "IsSelfStart");//是否自发起
            int PageIndex = RequestHelper.int_transfer(Request, "PageIndex");
            int PageSize = RequestHelper.int_transfer(Request, "PageSize");

            FuncType _FuncType = (FuncType)FuncType;
            try
            {
                jsonModel = Get_Eva_RegularData_Helper(PageIndex, PageSize, SectionID, ReguId, Key, SelectUID, Te, DepartmentID,ModelType, _FuncType, IsSelfStart);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        public static JsonModel Get_Eva_RegularData_Helper(int PageIndex, int PageSize, int SectionID, int ReguId,
            string Key, string SelectUID, string Te, string DepartmentID,int ModelType, FuncType _FuncType,int IsSelfStart)
        {
            int intSuccess = (int)errNum.Success;
            JsonModelNum jsm = new JsonModelNum();
            try
            {
                var export_tc = Constant.Expert_Teacher_Course_List;
                if (IsSelfStart>0) {
                    export_tc = (from etc in export_tc where etc.IsSelfStart == IsSelfStart select etc).ToList();
                }
                if (ModelType > 1)
                {
                    int SourceType = ModelType == 2 ? 1 : 2;
                    export_tc = (from etc in export_tc where etc.SourceType == SourceType select etc).ToList();
                }
                //获取数据【分校管理员和院系管理员】
                List<RegularDataModel> list = (from exp in export_tc
                                               join teacher in Constant.Teacher_List on exp.TeacherUID equals teacher.UniqueNo
                                               join regu in Constant.Eva_Regular_List on exp.ReguId equals Convert.ToString(regu.Id)
                                               join section in Constant.StudySection_List on regu.Section_Id equals section.Id
                                               join room in Constant.CourseRoom_List on exp.RoomID equals room.Id.ToString()
                                               orderby exp.CreateTime descending
                                               select new RegularDataModel()
                                               {
                                                   Num = 0,
                                                   Id = exp.Id,
                                                   TeacherName = exp.TeacherName,
                                                   TeacherUID = exp.TeacherUID,
                                                   ExpertName = exp.ExpertName,
                                                   ExpertUID = exp.ExpertUID,
                                                   Course_Name = exp.Course_Name,
                                                   CourseID = exp.CourseId,
                                                   DepartmentID = teacher.DepartmentID,
                                                   Departent_Name = teacher.DepartmentName,
                                                   ReguName = regu.Name,
                                                   StartTime = regu.StartTime,
                                                   EndTime = regu.EndTime,
                                                   State = "",
                                                   StateType = 0,
                                                   LookType = regu.LookType,
                                                   ReguId = regu.Id,
                                                   DisPlayName = section.DisPlayName,
                                                   SectionID = section.Id,
                                                   ClassName = room.ClassName,
                                                   ClassID = room.ClassID,
                                                   RoomID = exp.RoomID
                                               }).ToList();

                if (SectionID > 0)
                {
                    list = (from li in list where li.SectionID == SectionID select li).ToList();
                }

                if (ReguId > 0)
                {
                    list = (from li in list where li.ReguId == ReguId select li).ToList();
                }
                if (DepartmentID != "")
                {
                    list = (from li in list where li.DepartmentID == DepartmentID select li).ToList();
                }

                if (SelectUID != "")
                {
                    list = (from li in list where li.ExpertUID == SelectUID select li).ToList();
                }

                if (Te != "")
                {
                    list = (from li in list where li.TeacherUID == Te select li).ToList();
                }
                if (Key != "")
                {
                    list = (from li in list where li.TeacherName.Contains(Key)||li.ExpertName.Contains(Key) select li).ToList();
                }
                switch (_FuncType)
                {
                    case FuncType.common:

                        for (int i = 0; i < list.Count; i++)
                        {
                            list[i].Num = i + 1;
                        }

                        var query_last = (from an in list select an).Skip((PageIndex - 1) * PageSize).Take(PageSize).ToList();
                        foreach (var li in query_last)
                        {
                            ReguState regustate = ReguState.进行中;
                            if (li.StartTime < DateTime.Now && li.EndTime >= DateTime.Now)
                            {
                                regustate = ReguState.进行中;
                            }
                            else if (li.StartTime > DateTime.Now)
                            {
                                regustate = ReguState.未开始;
                            }
                            else
                            {
                                regustate = ReguState.已结束;
                            }
                            li.State = Convert.ToString(regustate);
                            li.StateType = (int)regustate;
                            li.AnswerCount = Constant.Eva_QuestionAnswer_List.Count(q => q.RelationID==li.Id && (q.State==(int)QueState.Submited|| q.State== (int)QueState.Checked));
                            li.TableCount = (from r in Constant.CourseRel_List
                                             where r.Course_Id == li.CourseID&&r.StudySection_Id==li.SectionID
                                             join t in Constant.Eva_CourseType_Table_List on new { CourseTypeId=r.CourseType_Id,r.StudySection_Id } equals new{ CourseTypeId=t.CourseTypeId,t.StudySection_Id}
                                             select r).ToList().Count();                                                  
                        }
                        //返回所有表格数据
                        jsm = JsonModelNum.GetJsonModel_o(intSuccess, "success", query_last);
                        jsm.PageIndex = PageIndex;
                        jsm.PageSize = PageSize;
                        jsm.PageCount = (int)Math.Ceiling((double)list.Count() / PageSize);
                        jsm.RowCount = list.Count();
                        break;
                    case FuncType.getcount:
                        bool result = false;
                        var currentRegu = Constant.Eva_Regular_List.FirstOrDefault(i =>i.Type==1&&(DateTime)i.StartTime <= DateTime.Now && (DateTime)i.EndTime >= DateTime.Now);
                        list = (from li in list where li.ReguId == currentRegu.Id select li).ToList();
                        if (currentRegu != null)
                        {                          
                            foreach (var li in list)
                            {
                                int AnswerCount = Constant.Eva_QuestionAnswer_List.Count(q =>q.AnswerUID == li.ExpertUID && q.TeacherUID == li.TeacherUID && 
                                    q.RelationID==li.Id && (q.State == (int)QueState.Submited || q.State == (int)QueState.Checked));
                                if (AnswerCount == 0)
                                {
                                    result = true;
                                }
                            }
                        }                      
                        //返回所有表格数据
                        jsm = JsonModelNum.GetJsonModel_o(intSuccess, "success", result);
                        break;
                    default:
                        break;
                }


            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return jsm;
        }

        /// <summary>
        /// 获取定期评价列表数据筛选
        /// </summary>
        /// <param name="context"></param>
        public void Get_Eva_RegularDataSelect(HttpContext context)
        {
            HttpRequest Request = context.Request;
            int SectionID = RequestHelper.int_transfer(Request, "SectionID");
            string SelectUID = RequestHelper.string_transfer(Request, "SelectUID");
            int SourceType= RequestHelper.int_transfer(Request, "SourceType");
            try
            {
                jsonModel = Get_Eva_RegularDataSelect_Helper(SectionID, SelectUID, SourceType);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        public static JsonModel Get_Eva_RegularDataSelect_Helper(int SectionID, string SelectUID,int SourceType)
        {
            int intSuccess = (int)errNum.Success;
            JsonModelNum jsm = new JsonModelNum();
            try
            {
                var export_tc = Constant.Expert_Teacher_Course_List.Where(t=>t.IsSelfStart==1);                
                if (SourceType>0)
                {                    
                    export_tc = (from etc in export_tc where etc.SourceType == SourceType select etc).ToList();
                }               
                var list = (from exp in export_tc
                            join teacher in Constant.Teacher_List on exp.TeacherUID equals teacher.UniqueNo
                            join regu in Constant.Eva_Regular_List on exp.ReguId equals Convert.ToString(regu.Id)
                            join section in Constant.StudySection_List on regu.Section_Id equals section.Id
                            join room in Constant.CourseRoom_List on exp.RoomID equals room.Id.ToString()
                            select new
                           {
                               SectionID = section.Id,

                               ReguId = regu.Id,
                               ReguName = regu.Name,

                               TeacherUID = teacher.UniqueNo,
                               TeacherName = teacher.Name,

                               ExpertUID = exp.ExpertUID,
                               exp.Type,

                           }).ToList();

                if (SectionID > 0)
                {
                    list = (from li in list where li.SectionID == SectionID select li).ToList();
                }
                if (SelectUID != "")
                {
                    list = (from li in list where li.ExpertUID == SelectUID select li).ToList();
                }
                var select = new
                {
                    RgList = (from li in list select new ReModel() { ReguId = li.ReguId, ReguName = li.ReguName }).Distinct(new ReModelComparer()).ToList(),
                    TeList = (from li in list select new TeModel { TeacherUID = li.TeacherUID, TeacherName = li.TeacherName }).Distinct(new TeModelComparer()).ToList(),
                };

                //返回所有表格数据
                jsm = JsonModelNum.GetJsonModel_o(intSuccess, "success", select);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return jsm;
        }

        /// <summary>
        /// 获取评价名称
        /// </summary>
        /// <param name="context"></param>
        public void Get_Eva_Regular_Name(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            try
            {
                HttpRequest Request = context.Request;

                var _list = (from t in Constant.Eva_Regular_List
                             where t.StartTime < DateTime.Now
                             select new { Name = t.Name }).Distinct();
                //返回所有表格数据
                jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", _list);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        #endregion

        #region 删除定期评价

        /// <summary>
        /// 删除定期评价
        /// </summary>
        public void Delete_Eva_Regular(HttpContext context)
        {
            HttpRequest Request = context.Request;
            //指标的ID
            int Id = RequestHelper.int_transfer(Request, "Id");
            int RoomID = RequestHelper.int_transfer(Request, "RoomID");
            try
            {
                jsonModel = Delete_Eva_RegularHelper(Id, RoomID);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        public static JsonModel Delete_Eva_RegularHelper(int Id, int RoomID)
        {
            JsonModel model = new JsonModel();
            int intSuccess = (int)errNum.Success;
            try
            {
                //获取指定要删除的定期评价
                Eva_Regular Eva_Regular_delete = Constant.Eva_Regular_List.FirstOrDefault(i => i.Id == Id);
                if (Eva_Regular_delete != null)
                {
                    var experlist_Count = Constant.Expert_Teacher_Course_List.Count(i => i.ReguId == Convert.ToString(Eva_Regular_delete.Id));
                    if (experlist_Count == 0)
                    {
                        var list = Split_Hepler.str_to_ints(Eva_Regular_delete.RoomID).ToList();
                        if (RoomID > 0 && list.Count > 1)
                        {
                            var clone = Constant.Clone(Eva_Regular_delete);

                            list.Remove(RoomID);
                            clone.RoomID = Split_Hepler.ints_to_string(list);

                            //数据库操作成功再改缓存
                            model = Constant.Eva_RegularService.Update(clone);
                            if (model.errNum == intSuccess)
                            {
                                Eva_Regular_delete.RoomID = clone.RoomID;
                            }
                            else
                            {
                                model = JsonModel.get_jsonmodel(3, "failed", "删除失败");
                            }
                        }
                        else
                        {
                            //数据库操作成功再改缓存
                            model = Constant.Eva_RegularService.Delete((int)Eva_Regular_delete.Id);
                            if (model.errNum == intSuccess)
                            {
                                Eva_Regular_delete.IsDelete = (int)IsDelete.Delete;
                                Constant.Eva_Regular_List.Remove(Eva_Regular_delete);
                            }
                            else
                            {
                                model = JsonModel.get_jsonmodel(3, "failed", "删除失败");
                            }
                        }

                    }
                    else
                    {
                        model = JsonModel.get_jsonmodel(3, "failed", "该定期评价已分配任务");
                    }
                }
                else
                {
                    model = JsonModel.get_jsonmodel(3, "failed", "该评价不存在");
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return model;
        }

        #endregion

        #region 编辑定期评价

        /// <summary>
        /// 修改定期评价
        /// </summary>
        public void Edit_Eva_Regular(HttpContext context)
        {
            HttpRequest Request = context.Request;
            //名称 开始时间 结束时间  最大百分比 最小百分比
            string Name = RequestHelper.string_transfer(Request, "Name");
            int Id = RequestHelper.int_transfer(Request, "Id");
            DateTime StartTime = RequestHelper.DateTime_transfer(Request, "StartTime");
            DateTime EndTime = RequestHelper.DateTime_transfer(Request, "EndTime");
            byte LookType = Convert.ToByte(Request["LookType"]);
            DateTime Look_StartTime = RequestHelper.DateTime_transfer(Request, "Look_StartTime");
            DateTime Look_EndTime = RequestHelper.DateTime_transfer(Request, "Look_EndTime");
            string MaxPercent = RequestHelper.string_transfer(Request, "MaxPercent");
            string MinPercent = RequestHelper.string_transfer(Request, "MinPercent");
            string Remarks = RequestHelper.string_transfer(Request, "Remarks");
            string EditUID = RequestHelper.string_transfer(Request, "EditUID");
            int Section_Id = RequestHelper.int_transfer(Request, "Section_Id");
            int Type = RequestHelper.int_transfer(Request, "Type");
            int TableID = RequestHelper.int_transfer(Request, "TableID");
            string DepartmentIDs = RequestHelper.string_transfer(Request, "DepartmentIDs");

            string CreateUID = RequestHelper.string_transfer(Request, "CreateUID");
            string RoomID = RequestHelper.string_transfer(Request, "RoomID");
            bool hasAcross = false;
            try
            {
                #region 查看是否交叉

                var reguList = (from regu in Constant.Eva_Regular_List where regu.Id != Id && regu.Type == Type select regu).ToList();

                if (Type == (int)ReguType.ClsStudent)
                {
                    reguList = new List<Eva_Regular>();
                }

                foreach (Eva_Regular regu in reguList)
                {
                    if (StartTime <= regu.StartTime && EndTime >= regu.EndTime)
                    {
                        hasAcross = true;
                        break;
                    }
                    if (StartTime >= regu.StartTime && StartTime <= regu.EndTime)
                    {
                        hasAcross = true;
                        break;
                    }
                    if (EndTime >= regu.StartTime && EndTime <= regu.EndTime)
                    {
                        hasAcross = true;
                        break;
                    }
                }

                #endregion

                if ((!hasAcross&& Type==1)||Type!=1)
                {
                    var section = Constant.StudySection_List.FirstOrDefault(i => i.Id == Section_Id);
                    if (section != null)
                    {
                        if (StartTime >= section.StartTime && EndTime <= section.EndTime)
                        {
                            #region 编辑评价

                            var reguEdit = Constant.Eva_Regular_List.FirstOrDefault(i => i.Id == Id);
                            if (reguEdit != null)
                            {
                                var regu_Clone = Constant.Clone<Eva_Regular>(reguEdit);

                                regu_Clone.Name = Name;
                                regu_Clone.StartTime = StartTime;
                                regu_Clone.EndTime = EndTime;
                                regu_Clone.LookType = LookType;
                                regu_Clone.Look_StartTime = Look_StartTime;
                                regu_Clone.Look_EndTime = Look_EndTime;
                                regu_Clone.MaxPercent = MaxPercent;
                                regu_Clone.MinPercent = MinPercent;
                                regu_Clone.Remarks = Remarks;
                                regu_Clone.EditTime = DateTime.Now;
                                regu_Clone.EditUID = EditUID;
                                regu_Clone.Type = Type;
                                regu_Clone.RoomID = RoomID;
                                regu_Clone.TableID = TableID;
                                regu_Clone.DepartmentIDs = DepartmentIDs;

                                //数据库添加
                                jsonModel = Constant.Eva_RegularService.Update(regu_Clone);
                                if (jsonModel.errNum == 0)
                                {
                                    reguEdit.Name = Name;
                                    reguEdit.StartTime = StartTime;
                                    reguEdit.EndTime = EndTime;
                                    reguEdit.LookType = LookType;
                                    reguEdit.Look_StartTime = Look_StartTime;
                                    reguEdit.Look_EndTime = Look_EndTime;
                                    reguEdit.MaxPercent = MaxPercent;
                                    reguEdit.MinPercent = MinPercent;
                                    reguEdit.Remarks = Remarks;
                                    reguEdit.EditTime = DateTime.Now;
                                    reguEdit.EditUID = EditUID;
                                    reguEdit.Type = Type;
                                    reguEdit.RoomID = RoomID;
                                    reguEdit.TableID = TableID;
                                    reguEdit.DepartmentIDs = DepartmentIDs;
                                }
                                else
                                {
                                    jsonModel = JsonModel.get_jsonmodel(3, "failed", "编辑失败");
                                }
                            }
                            else
                            {
                                jsonModel = JsonModel.get_jsonmodel(3, "failed", "该评价不存在");
                            }

                            #endregion
                        }
                        else
                        {
                            jsonModel = JsonModel.get_jsonmodel(3, "failed", "超出了该学年学期的时间范围");
                        }
                    }
                    else
                    {
                        jsonModel = JsonModel.get_jsonmodel(3, "failed", "添加失败");
                    }
                }
                else
                {
                    jsonModel = JsonModel.get_jsonmodel(3, "failed", "和已知的定期评价时间交叉");
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        #endregion

        #region 添加定期评价

        //上锁
        static object obj_Add_Eva_Regular = new object();
        /// <summary>
        /// 新增定期评价
        /// </summary>
        /// <param name="context">当前上下文</param>
        public void Add_Eva_Regular(HttpContext context)
        {
            lock (obj_Add_Eva_Regular)
            {
                HttpRequest Request = context.Request;
                //名称 开始时间 结束时间  最大百分比 最小百分比
                string Name = RequestHelper.string_transfer(Request, "Name");
                DateTime StartTime = RequestHelper.DateTime_transfer(Request, "StartTime");
                DateTime EndTime = RequestHelper.DateTime_transfer(Request, "EndTime");
                byte LookType = Convert.ToByte(Request["LookType"]);
                DateTime Look_StartTime = RequestHelper.DateTime_transfer(Request, "Look_StartTime");
                DateTime Look_EndTime = RequestHelper.DateTime_transfer(Request, "Look_EndTime");
                string MaxPercent = RequestHelper.string_transfer(Request, "MaxPercent");
                string MinPercent = RequestHelper.string_transfer(Request, "MinPercent");
                string Remarks = RequestHelper.string_transfer(Request, "Remarks");
                string CreateUID = RequestHelper.string_transfer(Request, "CreateUID");
                string EditUID = RequestHelper.string_transfer(Request, "EditUID");
                string RoomID = RequestHelper.string_transfer(Request, "RoomID");

                int Section_Id = RequestHelper.int_transfer(Request, "Section_Id");
                int Type = RequestHelper.int_transfer(Request, "Type");
                int TableID = RequestHelper.int_transfer(Request, "TableID");

                string DepartmentIDs = RequestHelper.string_transfer(Request, "DepartmentIDs");
                bool hasAcross = false;
                try
                {
                    #region 查看是否交叉

                    var reguList = (from regu in Constant.Eva_Regular_List where regu.Type == Type select regu).ToList();

                    if (Type == (int)ReguType.ClsStudent)
                    {
                        reguList = new List<Eva_Regular>();
                    }

                    foreach (Eva_Regular regu in reguList)
                    {
                        if (StartTime <= regu.StartTime && EndTime >= regu.EndTime)
                        {
                            hasAcross = true;
                            break;
                        }
                        if (StartTime >= regu.StartTime && StartTime <= regu.EndTime)
                        {
                            hasAcross = true;
                            break;
                        }
                        if (EndTime >= regu.StartTime && EndTime <= regu.EndTime)
                        {
                            hasAcross = true;
                            break;
                        }
                    }

                    #endregion

                    var section = Constant.StudySection_List.FirstOrDefault(i => i.Id == Section_Id);
                    if (section != null)
                    {
                        if (StartTime >= section.StartTime && EndTime <= section.EndTime)
                        {
                            #region 添加评价

                            if ((!hasAcross&& Type == 1)||Type!=1)
                            {
                                //新建定期评价
                                Eva_Regular Eva_Regular_Add = new Eva_Regular()
                                {
                                    Name = Name,
                                    Section_Id = Section_Id,
                                    StartTime = StartTime,
                                    EndTime = EndTime,
                                    LookType = LookType,
                                    Look_StartTime = Look_StartTime,
                                    Look_EndTime = Look_EndTime,
                                    MaxPercent = MaxPercent,
                                    MinPercent = MinPercent,
                                    Remarks = Remarks,
                                    CreateTime = DateTime.Now,
                                    CreateUID = CreateUID,
                                    EditTime = DateTime.Now,
                                    EditUID = EditUID,
                                    IsEnable = (int)IsEnable.Enable,
                                    IsDelete = (int)IsDelete.No_Delete,
                                    Type = Type,
                                    RoomID = RoomID,
                                    TableID = TableID,
                                    DepartmentIDs = DepartmentIDs,

                                };
                                if (TableID > 0)
                                {
                                    TableUsingAdd(TableID);
                                }

                                //数据库添加
                                jsonModel = Constant.Eva_RegularService.Add(Eva_Regular_Add);
                                if (jsonModel.errNum == 0)
                                {
                                    //从数据库返回的ID绑定
                                    Eva_Regular_Add.Id = Convert.ToInt32(jsonModel.retData);
                                    //缓存添加
                                    Constant.Eva_Regular_List.Add(Eva_Regular_Add);
                                }
                                else
                                {
                                    jsonModel = JsonModel.get_jsonmodel(3, "failed", "添加失败");
                                }
                            }
                            else
                            {
                                jsonModel = JsonModel.get_jsonmodel(3, "failed", "和已知的定期评价时间交叉");
                            }

                            #endregion
                        }
                        else
                        {
                            jsonModel = JsonModel.get_jsonmodel(3, "failed", "超出了该学年学期的时间范围");
                        }
                    }
                    else
                    {
                        jsonModel = JsonModel.get_jsonmodel(3, "failed", "添加失败");
                    }


                }
                catch (Exception ex)
                {
                    LogHelper.Error(ex);
                }
                finally
                {
                    //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                    context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
                }
            }
        }

        #endregion

        #region 获取近期的定期评价


        /// <summary>
        /// 定期评价  Eva_Role 1:专家评价  2:课堂评价
        /// </summary>
        /// <param name="Eva_Role"></param>
        /// <returns></returns>
        public static List<Eva_Regular> GetLastRegu(int Type)
        {
            List<Eva_Regular> list = new List<Eva_Regular>();
            try
            {
                list = (
                       from regu in Constant.Eva_Regular_List
                       where regu.StartTime < DateTime.Now && regu.EndTime >= DateTime.Now && regu.Type == Type
                       select regu).ToList();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return list;
        }


        #endregion

        #region 判断是否有专家评教的数据

        public void CheckHasExpertRegu(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            HttpRequest Request = context.Request;

            int Type = RequestHelper.int_transfer(Request, "Type");
            try
            {
                //教师          
                List<Eva_Regular> sele2 = GetLastRegu(Type);
                //返回所有表格数据
                jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", sele2);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】             
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        #endregion
    }
}