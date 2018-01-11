﻿using FEBLL;
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
        #region 获取

        /// <summary>
        /// 获取答题列表
        /// </summary>
        /// <param name="context"></param>
        public void Get_Eva_QuestionAnswer(HttpContext context)
        {
            lock (obj_Add_Eva_QuestionAnswer)
            {

                HttpRequest Request = context.Request;

                //学年学期的ID
                int SectionID = RequestHelper.int_transfer(Request, "SectionID");
                string DepartmentID = RequestHelper.string_transfer(Request, "DepartmentID");
                //课程的ID
                string Key = RequestHelper.string_transfer(Request, "Key");
                int Mode = RequestHelper.int_transfer(Request, "Mode");

                int TableID = RequestHelper.int_transfer(Request, "TableID");
                string AnswerUID = RequestHelper.string_transfer(Request, "AnswerUID");

                int PageIndex = RequestHelper.int_transfer(Request, "PageIndex");
                int PageSize = RequestHelper.int_transfer(Request, "PageSize");
                try
                {
                    ModeType modeType = (ModeType)Mode;
                    jsonModel = Get_Eva_QuestionAnswer_Helper(PageIndex, PageSize, SectionID, DepartmentID, Key, TableID, AnswerUID, modeType);
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

        /// <summary>
        /// 获取答题列表
        /// </summary>
        /// <param name="context"></param>
        public static JsonModel Get_Eva_QuestionAnswer_Helper(int PageIndex, int PageSize, int SectionID, string DepartmentID, string Key, int TableID, string AnswerUID, ModeType modeType)
        {
            int intSuccess = (int)errNum.Success;
            JsonModelNum jsm = new JsonModelNum();
            try
            {
                var list = (from q in Constant.Eva_QuestionAnswer_List
                            join u in Constant.UserInfo_List on q.TeacherUID equals u.UniqueNo
                            join d in Constant.Major_List on u.Major_ID equals d.Id
                            select new Eva_QuestionModel()
                            {
                                Id = q.Id,
                                SectionID = q.SectionID,
                                DisPlayName = q.DisPlayName,
                                TeacherUID = q.TeacherUID,
                                TeacherName = q.TeacherName,
                                CourseID = q.CourseID,
                                CourseName = q.CourseName,
                                DepartmentID = d.Id,
                                DepartmentName = d.Major_Name,
                                TableID = q.TableID,
                                TableName = q.TableName,
                                State = q.State,
                                Score = q.Score,
                                Num = 0,
                                ReguID = q.ReguID,
                                ReguName = q.ReguName,
                                AnswerUID = q.AnswerUID,
                                AnswerName = q.AnswerName,
                            }).ToList();

                if (SectionID > 0)
                {
                    list = (from li in list where li.SectionID == SectionID select li).ToList();
                }
                if (DepartmentID != "")
                {
                    list = (from li in list where li.DepartmentID == DepartmentID select li).ToList();
                }
                if (TableID > 0)
                {
                    list = (from li in list where li.TableID == TableID select li).ToList();
                }
                if (AnswerUID != "")
                {
                    list = (from li in list where li.AnswerUID == AnswerUID select li).ToList();
                }

                switch (modeType)
                {
                    case ModeType.Record:
                        if (Key != "")
                        {
                            list = (from li in list where li.CourseName.Contains(Key) || li.TeacherName.Contains(Key) select li).ToList();
                        }
                        break;
                    case ModeType.Check:
                        list = (from li in list where li.State == (int)QueState.Submited select li).ToList();
                        if (Key != "")
                        {
                            list = (from li in list where li.CourseName.Contains(Key) || li.TeacherName.Contains(Key) || li.AnswerName.Contains(Key) select li).ToList();
                        }
                        break;
                    case ModeType.Look:
                        break;
                    default:
                        break;
                }



                for (int i = 0; i < list.Count; i++)
                {
                    list[i].Num = i + 1;
                }

                var query_last = (from an in list select an).Skip((PageIndex - 1) * PageSize).Take(PageSize).ToList();
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
        /// 获取答题列表
        /// </summary>
        /// <param name="context"></param>
        public void Get_Eva_QuestionAnswerDetail(HttpContext context)
        {
            lock (obj_Add_Eva_QuestionAnswer)
            {

                HttpRequest Request = context.Request;
                int intSuccess = (int)errNum.Success;
                int intFailed = (int)errNum.Failed;
                //学年学期的ID
                int Id = RequestHelper.int_transfer(Request, "Id");

                try
                {
                    Eva_QuestionAnswer question = Constant.Eva_QuestionAnswer_List.FirstOrDefault(i => i.Id == Id);
                    if (question != null)
                    {
                        List<Eva_QuestionAnswer_Detail> list = (from detail in Constant.Eva_QuestionAnswer_Detail_List where detail.QuestionID == question.Id select detail).ToList();
                        List<Eva_QuestionAnswer_Header> headerList = (from header in Constant.Eva_QuestionAnswer_Header_List where header.QuestionID == question.Id select header).ToList();
                        var data = new
                        {
                            HeaderList = (from h in headerList orderby h.Id select new { h.CustomCode, h.Name, h.ValueID, h.Value, h.Id }),
                            DetailList = (from li in list select new { li.Answer, li.TableDetailID, li.QuestionType, li.Score }),
                            TableName = question.TableName,
                            Score = question.Score,
                        };
                        jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", data);
                    }
                    else
                    {
                        jsonModel = JsonModel.get_jsonmodel(intFailed, "failed", "该答题不存在");
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

        #region 添加

        //上锁int score
        static object obj_Add_Eva_QuestionAnswer = new object();
        /// <summary>
        /// 新增学生答题
        /// </summary>
        /// <param name="context">当前上下文</param>
        public void Add_Eva_QuestionAnswer(HttpContext context)
        {
            lock (obj_Add_Eva_QuestionAnswer)
            {
                int intSuccess = (int)errNum.Success;
                HttpRequest Request = context.Request;

                //学年学期的ID
                int SectionID = RequestHelper.int_transfer(Request, "SectionID");
                string DisPlayName = RequestHelper.string_transfer(Request, "DisPlayName");

                int ReguID = RequestHelper.int_transfer(Request, "ReguID");
                string ReguName = RequestHelper.string_transfer(Request, "ReguName");

                //课程的ID
                string CourseID = RequestHelper.string_transfer(Request, "CourseID");
                string CourseName = RequestHelper.string_transfer(Request, "CourseName");

                //教师的ID
                string TeacherUID = RequestHelper.string_transfer(Request, "TeacherUID");
                string TeacherName = RequestHelper.string_transfer(Request, "TeacherName");

                //学生【用户唯一标识符】
                string AnswerUID = RequestHelper.string_transfer(Request, "AnswerUID");
                string AnswerName = RequestHelper.string_transfer(Request, "AnswerName");

                int TableID = RequestHelper.int_transfer(Request, "TableID");
                string TableName = RequestHelper.string_transfer(Request, "TableName");

                int State = RequestHelper.int_transfer(Request, "State");
                //得分
                decimal Score = RequestHelper.decimal_transfer(Request, "Score");
                //创建者
                string CreateUID = RequestHelper.string_transfer(Request, "CreateUID");

                int Eva_Role = RequestHelper.int_transfer(Request, "Eva_Role");

                //答题详情明细
                string List = RequestHelper.string_transfer(Request, "List");

                //表头明显
                string HeaderList = RequestHelper.string_transfer(Request, "HeaderList");

                //课程分类
                var data = (from r in Constant.CourseRel_List
                            join c in Constant.Sys_Dictionary_List on r.CourseType_Id equals c.Key
                            where c.Type == "0"
                            select new { r, c }).ToList();

                try
                {
                    var first = data.Count > 0 ? data[0] : null;

                    #region 答题
                    //学生回答任务信息表
                    Eva_QuestionAnswer Eva_QuestionAnswer = new Eva_QuestionAnswer()
                    {
                        SectionID = SectionID,
                        DisPlayName = DisPlayName,
                        ReguID = ReguID,
                        ReguName = ReguName,
                        CourseTypeID = first != null ? first.c.Key : "",
                        CourseTypeName = first != null ? first.c.Value : "",
                        CourseID = CourseID,
                        CourseName = CourseName,
                        AnswerUID = AnswerUID,
                        AnswerName = AnswerName,
                        TeacherUID = TeacherUID,
                        TeacherName = TeacherName,
                        TableID = TableID,
                        TableName = TableName,
                        Score = Score,
                        State = State,
                        Eva_Role = Eva_Role,
                        CreateUID = CreateUID,
                        CreateTime = DateTime.Now,
                        EditTime = DateTime.Now,
                        EditUID = CreateUID,
                        IsDelete = (int)IsDelete.No_Delete,
                        IsEnable = (int)IsEnable.Enable
                    };
                    jsonModel = Constant.Eva_QuestionAnswerService.Add(Eva_QuestionAnswer);
                    if (jsonModel.errNum == intSuccess)
                    {
                        Eva_QuestionAnswer.Id = Convert.ToInt32(jsonModel.retData);
                    }

                    #endregion

                    if (jsonModel.errNum == intSuccess)
                    {
                        Constant.Eva_QuestionAnswer_List.Add(Eva_QuestionAnswer);

                        #region 表头添加

                        //序列化表单详情列表
                        List<Eva_QuestionAnswer_Header> Eva_QuestionAnswer_Header_List = JsonConvert.DeserializeObject<List<Eva_QuestionAnswer_Header>>(HeaderList);

                        //答题任务详情填充
                        foreach (Eva_QuestionAnswer_Header item in Eva_QuestionAnswer_Header_List)
                        {

                            item.QuestionID = Eva_QuestionAnswer.Id;
                            item.CreateTime = DateTime.Now;
                            item.CreateUID = AnswerUID;
                            item.EditUID = AnswerUID;
                            item.EditTime = DateTime.Now;
                            item.IsDelete = (int)IsDelete.No_Delete;
                            item.IsEnable = (int)IsEnable.Enable;
                            //数据库插入
                            JsonModel jsm = Constant.Eva_QuestionAnswer_HeaderService.Add(item);
                            //插入成功入缓存
                            if (jsm.errNum == intSuccess)
                            {
                                item.Id = Convert.ToInt32(jsm.retData);
                                Constant.Eva_QuestionAnswer_Header_List.Add(item);
                            }
                        }

                        #endregion

                        #region 答题详情


                        //序列化表单详情列表
                        List<Eva_QuestionAnswer_Detail> Eva_QuestionAnswer_Detail_List = JsonConvert.DeserializeObject<List<Eva_QuestionAnswer_Detail>>(List);

                        //答题任务详情填充
                        foreach (Eva_QuestionAnswer_Detail item in Eva_QuestionAnswer_Detail_List)
                        {
                            item.SectionID = SectionID;
                            item.DisPlayName = DisPlayName;
                            item.ReguID = ReguID;
                            item.ReguName = ReguName;
                            item.TeacherUID = TeacherUID;
                            item.TeacherName = TeacherName;
                            item.CourseTypeID = Eva_QuestionAnswer.CourseTypeID;
                            item.CourseTypeName = Eva_QuestionAnswer.CourseTypeName;
                            item.CourseID = CourseID;
                            item.CourseName = CourseName;
                            item.AnswerUID = AnswerUID;
                            item.AnswerName = AnswerName;
                            item.QuestionID = Eva_QuestionAnswer.Id;
                            item.TableID = TableID;
                            item.TableName = TableName;
                            item.Eva_Role = Eva_Role;

                            item.State = State;
                            item.CreateTime = DateTime.Now;
                            item.CreateUID = AnswerUID;
                            item.EditUID = AnswerUID;
                            item.EditTime = DateTime.Now;
                            item.IsDelete = (int)IsDelete.No_Delete;
                            item.IsEnable = (int)IsEnable.Enable;
                            //数据库插入
                            JsonModel jsm = Constant.Eva_QuestionAnswer_DetailService.Add(item);
                            //插入成功入缓存
                            if (jsm.errNum == intSuccess)
                            {
                                item.Id = Convert.ToInt32(jsm.retData);
                                Constant.Eva_QuestionAnswer_Detail_List.Add(item);
                            }
                        }

                        #endregion
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

        #region 编辑

        public void Edit_Eva_QuestionAnswer(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            HttpRequest Request = context.Request;
            int Id = RequestHelper.int_transfer(Request, "Id");
            int State = RequestHelper.int_transfer(Request, "State");
            //得分
            decimal Score = RequestHelper.decimal_transfer(Request, "Score");
            //答题详情明细
            string List = RequestHelper.string_transfer(Request, "List");
            //表头明显
            string HeaderList = RequestHelper.string_transfer(Request, "HeaderList");

            try
            {
                Eva_QuestionAnswer Eva_QuestionAnswer = Constant.Eva_QuestionAnswer_List.FirstOrDefault(q => q.Id == Id);
                List<Eva_QuestionAnswer_Header> headerList = (from h in Constant.Eva_QuestionAnswer_Header_List where h.QuestionID == Id select h).ToList();
                List<Eva_QuestionAnswer_Detail> detailList = (from q in Constant.Eva_QuestionAnswer_Detail_List where q.QuestionID == Id select q).ToList();
                Eva_QuestionAnswer Eva_QuestionAnswerClone = Constant.Clone(Eva_QuestionAnswer);
                Eva_QuestionAnswerClone.EditTime = DateTime.Now;
                Eva_QuestionAnswerClone.State = State;
                Eva_QuestionAnswerClone.Score = Score;
                jsonModel = Constant.Eva_QuestionAnswerService.Update(Eva_QuestionAnswerClone);

                if (jsonModel.errNum == intSuccess)
                {
                    Eva_QuestionAnswer.EditTime = DateTime.Now;
                    Eva_QuestionAnswer.State = State;
                    Eva_QuestionAnswer.Score = Score;

                    #region 表头添加

                    //序列化表单详情列表
                    List<Eva_QuestionAnswer_Header> Eva_QuestionAnswer_Header_List = JsonConvert.DeserializeObject<List<Eva_QuestionAnswer_Header>>(HeaderList);

                    //答题任务详情填充
                    foreach (Eva_QuestionAnswer_Header item in Eva_QuestionAnswer_Header_List)
                    {
                        Eva_QuestionAnswer_Header detail = headerList.FirstOrDefault(i => i.Id == item.Id);
                        if (detail != null)
                        {
                            Eva_QuestionAnswer_Header detailClone = Constant.Clone(detail);
                            detailClone.Value = item.Value;
                            detailClone.ValueID = item.ValueID;
                            detailClone.EditTime = DateTime.Now;
                            var jsm = Constant.Eva_QuestionAnswer_HeaderService.Update(detailClone);
                            if (jsm.errNum == 0)
                            {
                                detail.Value = item.Value;
                                detail.ValueID = item.ValueID;
                                detail.EditTime = DateTime.Now;
                            }
                        }
                    }

                    #endregion

                    #region 答题详情


                    //序列化表单详情列表
                    List<Eva_QuestionAnswer_Detail> Eva_QuestionAnswer_Detail_List = JsonConvert.DeserializeObject<List<Eva_QuestionAnswer_Detail>>(List);

                    //答题任务详情填充
                    foreach (Eva_QuestionAnswer_Detail item in Eva_QuestionAnswer_Detail_List)
                    {
                        Eva_QuestionAnswer_Detail detail = detailList.FirstOrDefault(i => i.TableDetailID == item.TableDetailID);
                        if (detail != null)
                        {
                            Eva_QuestionAnswer_Detail detailClone = Constant.Clone(detail);
                            detailClone.Answer = item.Answer;
                            detailClone.Score = item.Score;
                            detailClone.State = State;
                            detailClone.EditTime = DateTime.Now;
                            var jsm = Constant.Eva_QuestionAnswer_DetailService.Update(detailClone);
                            if (jsm.errNum == 0)
                            {
                                detail.Answer = item.Answer;
                                detail.Score = item.Score;
                                detail.State = State;
                                detail.EditTime = DateTime.Now;
                            }
                        }
                    }

                    #endregion
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

        #region 状态变更

        /// <summary>
        /// 状态变更
        /// </summary>
        /// <param name="context"></param>
        public void Change_Eva_QuestionAnswer_State(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            int intFailed = (int)errNum.Failed;
            HttpRequest Request = context.Request;
            int Id = RequestHelper.int_transfer(Request, "Id");
            int State = RequestHelper.int_transfer(Request, "State");
            try
            {
                Eva_QuestionAnswer answer = Constant.Eva_QuestionAnswer_List.FirstOrDefault(i => i.Id == Id);
                if (answer != null)
                {
                    Eva_QuestionAnswer answerClone = Constant.Clone(answer);
                    answerClone.State = State;
                    jsonModel = Constant.Eva_QuestionAnswerService.Update(answerClone);
                    if (jsonModel.errNum == intSuccess)
                    {
                        answer.State = State;
                        List<Eva_QuestionAnswer_Detail> details = (from d in Constant.Eva_QuestionAnswer_Detail_List where d.QuestionID == Id select d).ToList();
                        foreach (var item in details)
                        {
                            Eva_QuestionAnswer_Detail detailClone = Constant.Clone(item);
                            detailClone.State = State;
                            var jsm = Constant.Eva_QuestionAnswer_DetailService.Update(detailClone);
                            if (jsm.errNum == 0)
                            {
                                item.State = State;
                            }
                        }

                    }
                }
                else
                {
                    jsonModel = JsonModel.get_jsonmodel(intFailed, "failed", "操作失败");
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

        #region 删除

        /// <summary>
        /// 删除答题
        /// </summary>
        /// <param name="context"></param>
        public void Remove_Eva_QuestionAnswer(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            HttpRequest Request = context.Request;
            int Id = RequestHelper.int_transfer(Request, "Id");
            try
            {
                jsonModel = Constant.Eva_QuestionAnswerService.Delete(Id);
                if (jsonModel.errNum == intSuccess)
                {
                    Constant.Eva_QuestionAnswer_List.RemoveAll(i => i.Id == Id);

                    var header_ids = (from h in Constant.Eva_QuestionAnswer_Header_List where h.QuestionID == Id select Convert.ToString(h.Id)).ToArray();
                    var jsm = Constant.Eva_QuestionAnswer_HeaderService.DeleteBatch(header_ids);
                    if (jsm.errNum == 0)
                    {
                        Constant.Eva_QuestionAnswer_Header_List.RemoveAll(i => i.QuestionID == Id);
                    }

                    var detail_ids = (from d in Constant.Eva_QuestionAnswer_Detail_List where d.QuestionID == Id select Convert.ToString(d.Id)).ToArray();
                    var jsm2 = Constant.Eva_QuestionAnswer_DetailService.DeleteBatch(detail_ids);
                    if (jsm2.errNum == 0)
                    {
                        Constant.Eva_QuestionAnswer_Detail_List.RemoveAll(i => i.QuestionID == Id);
                    }
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

    }
}