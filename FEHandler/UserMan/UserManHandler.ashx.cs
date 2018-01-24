using FEHandler.Eva_Manage;
using FEModel;
using FEModel.Entity;
using FEModel.Enum;
using FEUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FEHandler.UserMan
{
    /// <summary>
    /// UserManHandler 的摘要说明
    /// </summary>
    public class UserManHandler : IHttpHandler
    {
        #region 中心入口

        JsonModel jsonModel = new JsonModel();
        public void ProcessRequest(HttpContext context)
        {
            HttpRequest Request = context.Request;
            string func = RequestHelper.string_transfer(Request, "func");
            try
            {
                switch (func)
                {
                    //获取用户
                    case "Get_UserInfo_List": Get_UserInfo_List(context); break;
                    //根据用户组获取用户
                    case "Get_UserByRoleID": Get_UserByRoleID(context); break;
                    case "Get_UserByRole_Select": Get_UserByRole_Select(context); break;


                    //操作用户组
                    case "Ope_UserGourp": Ope_UserGourp(context); break;

                    //获取指标库
                    case "Get_UserGroup": Get_UserGroup(context); break;
                    //获取用户信息【根据类型】
                    case "GetUserByType": GetUserByType(context); break;
                    //获取用户信息【根据类型】+课程【教师组】
                    case "GetUserByType_Course": GetUserByType_Course(context); break;
                    case "SetUserToRole": SetUserToRole(context); break;

                    case "IsMutex": IsMutex(context); break;

                    case "GetTeachers": GetTeachers(context); break;
                    case "GetTeachers_New": GetTeachers_New(context); break;

                    case "GetStudents": GetStudents(context); break;
                    case "GetStudentsSelect": GetStudentsSelect(context); break;
                    case "GetMajors": GetMajors(context); break;

                    default:
                        jsonModel = JsonModel.get_jsonmodel(5, "没有此方法", "");
                        context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
                        break;
                }

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                jsonModel = JsonModel.get_jsonmodel(7, "出现异常,请通知管理员", "");
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        #endregion

        #region 部门
        public void GetMajors(HttpContext context)
        {
            List<Major> Major_List = Constant.Major_List;
            int intSuccess = (int)errNum.Success;
            jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", Major_List);
            context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
        }

        #endregion

        #region 角色设置

        public void SetUserToRole(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            try
            {
                HttpRequest Request = context.Request;
                string UniqueNos = RequestHelper.string_transfer(Request, "UniqueNo");
                int Roleid = RequestHelper.int_transfer(Request, "Roleid");
                string[] us = Split_Hepler.str_to_stringss(UniqueNos);
                bool IsMutexCombine = RequestHelper.bool_transfer(Request, "IsMutexCombine");
                //互斥
                if (IsMutexCombine)
                {
                    //-----------------------------------------------------------------------
                    //先把选中的 角色进行判断性的变更【若不为改类型则设置为该类型】
                    foreach (var unique in us)
                    {
                        Sys_RoleOfUser Sys_RoleOfUser = Constant.Sys_RoleOfUser_List.FirstOrDefault(r => r.UniqueNo == unique);
                        if (Sys_RoleOfUser != null)
                        {
                            RoleUserUpdate(Roleid, Sys_RoleOfUser);
                        }
                        else
                        {
                            RoleUserAdd(Roleid, unique);
                        }
                    }
                }
                else
                {
                    //-----------------------------------------------------------------------
                    //先把选中的 角色进行判断性的变更【若不为改类型则设置为该类型】
                    foreach (var unique in us)
                    {
                        int count = Constant.Sys_RoleOfUser_List.Count(r => r.UniqueNo == unique && r.Role_Id == Roleid);
                        if (count == 0)
                        {
                            RoleUserAdd(Roleid, unique);
                        }
                    }
                }
                string[] deleteDatas = (from r in Constant.Sys_RoleOfUser_List where !us.Contains(r.UniqueNo) && r.Role_Id == Roleid select Convert.ToString(r.Id)).ToArray();
                if (deleteDatas.Count() > 0)
                {
                    var jsm = Constant.Sys_RoleOfUserService.DeleteBatch(deleteDatas);
                    if (jsm.errNum == 0)
                    {
                        Constant.Sys_RoleOfUser_List.RemoveAll(r => deleteDatas.Contains(Convert.ToString(r.Id)));
                    }
                }
                jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", "0");

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

        private static void RoleUserUpdate(int Roleid, Sys_RoleOfUser Sys_RoleOfUser)
        {
            try
            {
                Sys_RoleOfUser Sys_RoleOfUser_Clone = Constant.Clone(Sys_RoleOfUser);
                Sys_RoleOfUser_Clone.Role_Id = Roleid;
                //改数据库
                JsonModel m1 = Constant.Sys_RoleOfUserService.Update(Sys_RoleOfUser_Clone);
                if (m1.errNum == 0)
                {
                    Sys_RoleOfUser.Role_Id = Roleid;
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
        }

        private static void RoleUserAdd(int Roleid, string unique)
        {
            try
            {
                Sys_RoleOfUser r = new Sys_RoleOfUser()
                {
                    Role_Id = Roleid,
                    IsDelete = (int)IsDelete.No_Delete,
                    CreateTime = DateTime.Now,
                    EditTime = DateTime.Now,
                    UniqueNo = unique,
                    CreateUID = "",
                    EditUID = "",
                };
                //改数据库
                JsonModel m1 = Constant.Sys_RoleOfUserService.Add(r);
                if (m1.errNum == 0)
                {
                    Constant.Sys_RoleOfUser_List.Add(r);
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
        }

        public void IsMutex(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            try
            {
                HttpRequest Request = context.Request;
                string UniqueNos = RequestHelper.string_transfer(Request, "UniqueNo");
                string[] us = Split_Hepler.str_to_stringss(UniqueNos);
                int Roleid = RequestHelper.int_transfer(Request, "Roleid");
                //-----------------------------------------------------------------------
                RoleType roleType = (RoleType)Roleid;

                bool reuslt = true;
                string info = string.Empty;
                if (roleType == RoleType.department_mange || roleType == RoleType.school_manage)
                {
                    //先把选中的 角色进行判断性的变更【若不为改类型则设置为该类型】
                    var inf = (from uni in us
                               join r_u in Constant.Sys_RoleOfUser_List on uni equals r_u.UniqueNo
                               join r in Constant.Sys_Role_List on r_u.Role_Id equals r.Id
                               join user in Constant.UserInfo_List on uni equals user.UniqueNo
                               where r.Id == (int)RoleType.department_mange || r.Id == (int)RoleType.school_manage
                               select new MuteUser { UserName = user.Name, RoleName = r.Name, RoleID = r.Id }).ToList();
                    inf = (from i in inf where i.RoleID != Roleid select i).ToList();
                    if (inf.Count > 0)
                    {
                        reuslt = false;
                    }
                    var data = new { IsMutex = reuslt, inf };
                    jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", data);
                }
                else
                {
                    var data = new { IsMutex = reuslt, Info = "" };
                    jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", data);
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

        #region 获取用户组

        public void Get_UserGroup(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            try
            {
                HttpRequest Request = context.Request;
                //返回所有用户信息

                List<Sys_Role> Sys_Role_List = Constant.Sys_Role_List;
                var query = from srl in Sys_Role_List
                            where srl.Name != "超级管理员"
                            orderby srl.Sort
                            select new
                            {
                                RoleId = srl.Id,
                                RoleName = srl.Name,
                                Code = srl.Code,

                            };
                jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", query);
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
            //LogHelper.Info("Get_UserGroup:结束");
        }

        #endregion

        #region 添加\编辑\删除 用户组

        static object Ope_UserGourp_Obj = new object();

        public void Ope_UserGourp(HttpContext context)
        {
            lock (Ope_UserGourp_Obj)
            {
                try
                {
                    HttpRequest Request = context.Request;
                    //返回所有用户信息

                    int Id = RequestHelper.int_transfer(Request, "Id");
                    string Name = RequestHelper.string_transfer(Request, "Name");
                    int Type = RequestHelper.int_transfer(Request, "Type");//1：添加   2：编辑 3：删除
                    string UniqueNo = RequestHelper.string_transfer(Request, "UniqueNo");
                    switch (Type)
                    {
                        case 1:
                            User_Gourp_Add_Helper(Name, UniqueNo);

                            break;
                        case 2:
                            User_Gourp_Edit_Helper(Id, Name, UniqueNo);

                            break;
                        case 3:
                            User_Gourp_Delete_Helper(Id, UniqueNo);

                            break;
                        default:
                            break;
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

        private void User_Gourp_Edit_Helper(int Id, string Name, string UniqueNo)
        {
            try
            {

                if (Id > 0)
                {
                    //编辑
                    var role_edit = Constant.Sys_Role_List.FirstOrDefault(r => r.Id == Id);
                    if (role_edit != null)
                    {
                        var role_Clone = Constant.Clone<Sys_Role>(role_edit);
                        if (role_Clone != null)
                        {
                            role_Clone.Name = Name;
                            role_Clone.EditTime = DateTime.Now;
                            role_Clone.EditUID = UniqueNo;
                            jsonModel = Constant.Sys_RoleService.Update(role_Clone);
                            if (jsonModel.errNum == 0)
                            {
                                role_edit.Name = Name;
                                role_edit.EditTime = DateTime.Now;
                                role_edit.EditUID = UniqueNo;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
        }

        private void User_Gourp_Delete_Helper(int Id, string UniqueNo)
        {
            try
            {
                if (Id > 0)
                {
                    //编辑
                    var role_edit = Constant.Sys_Role_List.FirstOrDefault(r => r.Id == Id);
                    if (role_edit != null)
                    {
                        var r_Count = Constant.Sys_RoleOfUser_List.Count(i => i.Role_Id == Id);//角色成员
                        if (r_Count == 0)
                        {
                            var role_Clone = Constant.Clone<Sys_Role>(role_edit);
                            if (role_Clone != null)
                            {
                                role_Clone.IsDelete = 1;
                                role_Clone.EditUID = UniqueNo;
                                role_Clone.EditTime = DateTime.Now;
                                jsonModel = Constant.Sys_RoleService.Update(role_Clone);
                                if (jsonModel.errNum == 0)
                                {
                                    role_edit.IsDelete = 1;
                                    role_edit.EditUID = UniqueNo;
                                    role_edit.EditTime = DateTime.Now;
                                    Constant.Sys_Role_List.Remove(role_edit);
                                }
                            }
                        }
                        else
                        {
                            jsonModel = JsonModel.get_jsonmodel(3, "已分配成员不可删除", 0);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
        }

        private void User_Gourp_Add_Helper(string Name, string UniqueNo)
        {
            try
            {
                //排序
                var sortMax = Constant.Sys_Role_List.Max(r => r.Sort);
                //添加用户组
                Sys_Role role_new = new Sys_Role()
                {
                    Code = "0",// 0:非固化[可编辑 删除] 1:固化
                    CreateUID = UniqueNo,
                    CreateTime = DateTime.Now,
                    IsDelete = 0,
                    Name = Name,
                    Sort = sortMax + 1,
                };
                jsonModel = Constant.Sys_RoleService.Add(role_new);
                if (jsonModel.errNum == 0)
                {
                    role_new.Id = Convert.ToInt32(jsonModel.retData);
                    Constant.Sys_Role_List.Add(role_new);
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
        }

        #endregion

        #region 获取用户信息

        //获取用户信息
        public void Get_UserInfo_List(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            try
            {
                HttpRequest Request = context.Request;
                //返回所有用户信息

                List<UserInfo> UserInfo_List_ = Constant.UserInfo_List;
                List<Sys_Role> Sys_Role_List = Constant.Sys_Role_List;
                List<Sys_RoleOfUser> Sys_RoleOfUser_List = Constant.Sys_RoleOfUser_List;
                List<Major> Major_List = Constant.Major_List;
                var query = from ul in UserInfo_List_
                            join SysRoleOfUser in Sys_RoleOfUser_List on ul.UniqueNo equals SysRoleOfUser.UniqueNo
                            join SysRole in Sys_Role_List on SysRoleOfUser.Role_Id equals SysRole.Id
                            join stu in Constant.Student_List on ul.UniqueNo equals stu.UniqueNo into clasStus
                            from stu_ in clasStus.DefaultIfEmpty()
                            where SysRole.Name != "超级管理员"
                            orderby SysRole.Sort
                            select new
                 {
                     id = ul.Id,
                     Name = (ul.Name == null) ? string.Empty : ul.Name,
                     Sex = GetSex(Convert.ToString(ul.Sex)),
                     LoginName = (ul.LoginName == null) ? string.Empty : ul.LoginName,
                     Phone = (ul.Phone == null) ? string.Empty : ul.Phone,
                     Email = (ul.Email == null) ? string.Empty : ul.Email,
                     UserType = ul.UserType,
                     Roleid = SysRole.Id,
                     RoleName = SysRole.Name,
                     UniqueNo = ul.UniqueNo,
                     Pwd = ul.ClearPassword,

                     Major_ID = ul.Major_ID,
                     DepartmentName = ul.DepartmentName,

                     SubDepartmentID = ul.SubDepartmentID,
                     SubDepartmentName = ul.SubDepartmentName,

                     ClassID = stu_ != null ? stu_.ClassNo : "",
                     ClassName = stu_ != null ? stu_.ClassName : "",
                 };
                var data = new
                {
                    MainData = query,
                    DPList = (from q in query
                              where q.DepartmentName != ""
                              select new DPModel()
                                  {
                                      Major_ID = q.Major_ID,
                                      DepartmentName = q.DepartmentName,
                                  }).Distinct(new DPModelComparer()),
                    ClsList = (from q in query where q.ClassID != "" select new ClsModel() { ClassID = q.ClassID, ClassName = q.ClassName, Major_ID = q.Major_ID }).Distinct(new ClsModelComparer()),
                };
                jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", data);
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
        public string GetSex(string sexflg)
        {
            if (sexflg == "0") { return "女"; }
            else if (sexflg == "1") { return "男"; }
            else { return ""; }
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        #endregion

        #region 指定类型获取用户信息

        public void GetUserByType(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            try
            {
                HttpRequest Request = context.Request;
                string type = RequestHelper.string_transfer(Request, "type");
                if (!string.IsNullOrEmpty(type))
                {
                    int[] types = Split_Hepler.str_to_ints(type);

                    List<UserInfo> UserInfo_List_ = Constant.UserInfo_List;
                    List<Sys_Role> Sys_Role_List = Constant.Sys_Role_List;
                    List<Sys_RoleOfUser> Sys_RoleOfUser_List = Constant.Sys_RoleOfUser_List;
                    var query = (from ul in UserInfo_List_
                                 //where ul.UserType ==type
                                 join SysRoleOfUser in Sys_RoleOfUser_List on ul.UniqueNo equals SysRoleOfUser.UniqueNo
                                 where types.Contains((int)SysRoleOfUser.Role_Id)
                                 join SysRole in Sys_Role_List on SysRoleOfUser.Role_Id equals SysRole.Id
                                 orderby SysRole.Sort
                                 select new
                                 {
                                     id = ul.Id,
                                     Name = (ul.Name == null) ? string.Empty : ul.Name,
                                     Sex = GetSex(Convert.ToString(ul.Sex)),
                                     LoginName = (ul.LoginName == null) ? string.Empty : ul.LoginName,
                                     Phone = (ul.Phone == null) ? string.Empty : ul.Phone,
                                     Email = (ul.Email == null) ? string.Empty : ul.Email,
                                     UserType = ul.UserType,
                                     Roleid = SysRole.Id,
                                     Pwd = ul.ClearPassword,
                                     UniqueNo = ul.UniqueNo,
                                     MajorId = ul.Major_ID,

                                 }).ToList();

                    int count = query.Count();

                    jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", query);
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

        #region 指定类型获取用户信息【包含教师所教课程】

        public void GetUserByType_Course(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            try
            {
                HttpRequest Request = context.Request;
                var college_TeacherUID = RequestHelper.string_transfer(Request, "college_TeacherUID");
                object query = new object();
                //if (string.IsNullOrEmpty(college_TeacherUID))
                //{

                //    var major_id = (from t in Constant.Teacher_List where t.UniqueNo == college_TeacherUID select t.Major_ID).First();

                //    int type = RequestHelper.int_transfer(Request, "type");
                //    List<UserInfo> UserInfo_List_ = Constant.UserInfo_List;
                //    List<Sys_Role> Sys_Role_List = Constant.Sys_Role_List;
                //    List<Sys_RoleOfUser> Sys_RoleOfUser_List = Constant.Sys_RoleOfUser_List;
                //    query = (from ul in UserInfo_List_
                //             where ul.Major_ID== major_id
                //             join SysRoleOfUser in Sys_RoleOfUser_List on ul.UniqueNo equals SysRoleOfUser.UniqueNo
                //             where SysRoleOfUser.Role_Id == type
                //             join SysRole in Sys_Role_List on SysRoleOfUser.Role_Id equals SysRole.Id
                //             join t in Constant.Teacher_List on ul.UniqueNo equals t.UniqueNo                            
                //             join major in Constant.Major_List on t.Major_ID equals major.Id

                //             orderby SysRole.Sort
                //             select new
                //             {
                //                 a_Id = ul.Id,
                //                 a_Name = (ul.Name == null) ? string.Empty : ul.Name,
                //                 a_Sex = GetSex(Convert.ToString(ul.Sex)),
                //                 a_LoginName = (ul.LoginName == null) ? string.Empty : ul.LoginName,
                //                 a_Phone = (ul.Phone == null) ? string.Empty : ul.Phone,
                //                 a_Email = (ul.Email == null) ? string.Empty : ul.Email,
                //                 a_UserType = ul.UserType,
                //                 a_Roleid = SysRole.Id,
                //                 a_Pwd = ul.ClearPassword,
                //                 a_UniqueNo = ul.UniqueNo,
                //                 list = (from c1 in Constant.CourseRoom_List.Distinct()
                //                         where c1.TeacherUID == ul.UniqueNo
                //                         join c2 in Constant.Course_List on c1.Coures_Id equals c2.UniqueNo
                //                         select c2).Distinct().ToList()
                //             }).ToList();
                //}
                //else
                //{

                int type = RequestHelper.int_transfer(Request, "type");
                List<UserInfo> UserInfo_List_ = Constant.UserInfo_List;
                List<Sys_Role> Sys_Role_List = Constant.Sys_Role_List;
                List<Sys_RoleOfUser> Sys_RoleOfUser_List = Constant.Sys_RoleOfUser_List;
                query = (from ul in UserInfo_List_
                         join SysRoleOfUser in Sys_RoleOfUser_List on ul.UniqueNo equals SysRoleOfUser.UniqueNo
                         where SysRoleOfUser.Role_Id == type
                         join SysRole in Sys_Role_List on SysRoleOfUser.Role_Id equals SysRole.Id
                         join t in Constant.Teacher_List on ul.UniqueNo equals t.UniqueNo
                         join major in Constant.Major_List on t.DepartmentID equals major.Id
                         orderby SysRole.Sort
                         select new
                         {
                             a_Id = ul.Id,
                             a_Name = (ul.Name == null) ? string.Empty : ul.Name,
                             a_Sex = GetSex(Convert.ToString(ul.Sex)),
                             a_LoginName = (ul.LoginName == null) ? string.Empty : ul.LoginName,
                             a_Phone = (ul.Phone == null) ? string.Empty : ul.Phone,
                             a_Email = (ul.Email == null) ? string.Empty : ul.Email,
                             a_UserType = ul.UserType,
                             a_Roleid = SysRole.Id,
                             a_Pwd = ul.ClearPassword,
                             a_UniqueNo = ul.UniqueNo,
                             list = (from c1 in Constant.CourseRoom_List.Distinct()
                                     where c1.TeacherUID == ul.UniqueNo
                                     join c2 in Constant.Course_List on c1.Coures_Id equals c2.UniqueNo
                                     select c2).Distinct().ToList()
                         }).ToList();
                //}

                jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", query);
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

        #region 获取学生

        public void GetStudents(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            try
            {
                HttpRequest Request = context.Request;
                //返回所有用户信息



                List<UserInfo> UserInfo_List_ = Constant.UserInfo_List;
                List<Major> Major_List = Constant.Major_List;

                var query = from ul in UserInfo_List_
                            join s in Constant.Student_List on ul.UniqueNo equals s.UniqueNo
                            select new
                            {
                                id = ul.Id,
                                Name = (ul.Name == null) ? string.Empty : ul.Name,
                                Sex = GetSex(Convert.ToString(ul.Sex)),
                                LoginName = (ul.LoginName == null) ? string.Empty : ul.LoginName,
                                Phone = (ul.Phone == null) ? string.Empty : ul.Phone,
                                Email = (ul.Email == null) ? string.Empty : ul.Email,
                                UserType = ul.UserType,
                                Roleid = 2,
                                RoleName = "学生",
                                UniqueNo = ul.UniqueNo,
                                Pwd = ul.ClearPassword,
                                MajorName = "",
                                Major_ID = ul.Major_ID,
                                s.SubDepartmentID,
                                s.SubDepartmentName,
                            };

                var query1 = from q in query
                             join SysMajor in Major_List on q.Major_ID equals SysMajor.Id
                             into gj
                             from lf in gj.DefaultIfEmpty()
                             select new
                             {
                                 id = q.id,
                                 Name = (q.Name == null) ? string.Empty : q.Name,
                                 Sex = q.Sex,
                                 LoginName = (q.LoginName == null) ? string.Empty : q.LoginName,
                                 Phone = (q.Phone == null) ? string.Empty : q.Phone,
                                 Email = (q.Email == null) ? string.Empty : q.Email,
                                 UserType = q.UserType,
                                 Roleid = q.Roleid,
                                 RoleName = q.RoleName,
                                 UniqueNo = q.UniqueNo,
                                 Pwd = q.Pwd,
                                 MajorName = (lf == null ? "" : lf.Major_Name),
                                 Major_ID = q.Major_ID,
                                 q.SubDepartmentID,
                                 q.SubDepartmentName,
                             };



                int count = query1.Count();

                jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", query1);
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

        public void GetStudentsSelect(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            try
            {
                HttpRequest Request = context.Request;
                //返回所有用户信息

                string ClassID = RequestHelper.string_transfer(Request, "ClassID");

                List<UserInfo> UserInfo_List_ = Constant.UserInfo_List;
                List<Major> Major_List = Constant.Major_List;

                var query = from ul in UserInfo_List_
                            join s in Constant.Student_List on ul.UniqueNo equals s.UniqueNo
                            select new
                            {
                                id = ul.Id,
                                Name = (ul.Name == null) ? string.Empty : ul.Name,
                                Sex = GetSex(Convert.ToString(ul.Sex)),
                                LoginName = (ul.LoginName == null) ? string.Empty : ul.LoginName,
                                Phone = (ul.Phone == null) ? string.Empty : ul.Phone,
                                Email = (ul.Email == null) ? string.Empty : ul.Email,
                                UserType = ul.UserType,
                                Roleid = 2,
                                RoleName = "学生",
                                UniqueNo = ul.UniqueNo,
                                Pwd = ul.ClearPassword,
                                MajorName = "",
                                Major_ID = ul.Major_ID,
                                s.ClassNo,
                                s.ClassName,
                            };
                if (ClassID != "")
                {
                    query = (from q in query where q.ClassNo == ClassID select q).ToList();
                }
                var data = new { StuList = (from q in query select new { q.UniqueNo, q.Name }) };

                jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", data);
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

        #region 获取教师

        public void GetTeachers(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            try
            {
                HttpRequest Request = context.Request;
                string Major_ID = RequestHelper.string_transfer(context.Request, "Major_ID");
                //返回所有用户信息
                List<UserInfo> UserInfo_List_ = Constant.UserInfo_List;
                if (!string.IsNullOrEmpty(Major_ID))
                {
                    UserInfo_List_ = UserInfo_List_.Where(t => t.Major_ID == Major_ID).ToList();
                }
                List<Major> Major_List = Constant.Major_List;
                var query = from ul in UserInfo_List_
                            join s in Constant.Teacher_List on ul.UniqueNo equals s.UniqueNo
                            select new
                            {
                                id = ul.Id,
                                Name = (ul.Name == null) ? string.Empty : ul.Name,
                                Sex = GetSex(Convert.ToString(ul.Sex)),
                                LoginName = (ul.LoginName == null) ? string.Empty : ul.LoginName,
                                Phone = (ul.Phone == null) ? string.Empty : ul.Phone,
                                Email = (ul.Email == null) ? string.Empty : ul.Email,
                                UserType = ul.UserType,
                                Roleid = 0,
                                RoleName = "教师",
                                UniqueNo = ul.UniqueNo,
                                Pwd = ul.ClearPassword,
                                MajorName = "",
                                Major_ID = ul.Major_ID,
                                s.SubDepartmentID,
                                s.SubDepartmentName
                            };

                var query1 = from q in query
                             join SysMajor in Major_List on q.Major_ID equals SysMajor.Id
                             into gj
                             from lf in gj.DefaultIfEmpty()
                             select new
                             {
                                 id = q.id,
                                 Name = (q.Name == null) ? string.Empty : q.Name,
                                 Sex = q.Sex,
                                 LoginName = (q.LoginName == null) ? string.Empty : q.LoginName,
                                 Phone = (q.Phone == null) ? string.Empty : q.Phone,
                                 Email = (q.Email == null) ? string.Empty : q.Email,
                                 UserType = q.UserType,
                                 Roleid = q.Roleid,
                                 RoleName = q.RoleName,
                                 UniqueNo = q.UniqueNo,
                                 Pwd = q.Pwd,
                                 MajorName = (lf == null ? "" : lf.Major_Name),
                                 Major_ID = q.Major_ID,
                                 q.SubDepartmentID,
                                 q.SubDepartmentName
                             };
                int count = query1.Count();
                jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", query1);
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

        public void GetTeachers_New(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            try
            {
                HttpRequest Request = context.Request;               
                //返回所有用户信息
                List<UserInfo> UserInfo_List_ = Constant.UserInfo_List;
                var query = from tea in Constant.Teacher_List
                          
                            select new
                            {
                                Name = (tea.Name == null) ? string.Empty : tea.Name,
                                Sex = GetSex(Convert.ToString(tea.Sex)),
                                Roleid = (int)RoleType.teacher,
                                UniqueNo = tea.UniqueNo,
                                MajorName = tea.DepartmentName,
                                Major_ID = tea.DepartmentID,
                                SubDepartmentID = tea.SubDepartmentID,
                                SubDepartmentName = tea.SubDepartmentName,

                                TeachDate = tea.TeacherSchooldate,
                                Birthday = tea.TeacherBirthday,
                                Status = tea.Status,
                            };

                int count = query.Count();
                jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", query);
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

        #region 根据角色获取用户信息

        /// <summary>
        /// 获取定期评价列表数据
        /// </summary>
        public void Get_UserByRoleID(HttpContext context)
        {
            HttpRequest Request = context.Request;
            string Key = RequestHelper.string_transfer(Request, "Key");
            string Dp = RequestHelper.string_transfer(Request, "Dp");
            string Cls = RequestHelper.string_transfer(Request, "Cls");
            int RoleID = RequestHelper.int_transfer(Request, "RoleID");

            int PageIndex = RequestHelper.int_transfer(Request, "PageIndex");
            int PageSize = RequestHelper.int_transfer(Request, "PageSize");
            try
            {
                jsonModel = Get_UserByRoleID_Helper(PageIndex, PageSize, RoleID, Key, Dp, Cls);
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

        public static JsonModel Get_UserByRoleID_Helper(int PageIndex, int PageSize, int RoleID, string Key, string Dp, string Cls)
        {
            int intSuccess = (int)errNum.Success;
            JsonModelNum jsm = new JsonModelNum();
            try
            {
                var list = (from user in Constant.UserInfo_List
                            join stu in Constant.Student_List on user.UniqueNo equals stu.UniqueNo into stus
                            from stu_ in stus.DefaultIfEmpty()
                            join ru in Constant.Sys_RoleOfUser_List on user.UniqueNo equals ru.UniqueNo
                            join role in Constant.Sys_Role_List on ru.Role_Id equals role.Id
                            where role.Id == RoleID
                            select new UserModel
                            {
                                Num = 0,
                                UniqueNo = user.UniqueNo,
                                Name = user.Name,
                                Sex = user.Sex,
                                DepartmentID = user.Major_ID,
                                DepartmentName = user.DepartmentName,
                                SubDepartmentName = user.SubDepartmentName,
                                ClassID = stu_ != null ? stu_.ClassNo : "",
                                ClassName = stu_ != null ? stu_.ClassName : "",
                            }).ToList();

                if (Dp != "")
                {
                    list = (from li in list where li.DepartmentID == Dp select li).ToList();
                }

                if (Cls != "")
                {
                    list = (from li in list where li.ClassID == Cls select li).ToList();
                }
                if (Key != "")
                {
                    list = (from li in list where li.Name.Contains(Key) || li.UniqueNo.Contains(Key) select li).ToList();
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
        /// 获取定期评价列表数据
        /// </summary>
        public void Get_UserByRole_Select(HttpContext context)
        {
            HttpRequest Request = context.Request;
            try
            {
                jsonModel = Get_UserByRole_Select_Helper();
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

        public static JsonModel Get_UserByRole_Select_Helper()
        {
            int intSuccess = (int)errNum.Success;
            JsonModel jsm = new JsonModel();
            try
            {
                var list = (from user in Constant.UserInfo_List
                            join stu in Constant.Student_List on user.UniqueNo equals stu.UniqueNo into stus
                            from stu_ in stus.DefaultIfEmpty()
                            join ru in Constant.Sys_RoleOfUser_List on user.UniqueNo equals ru.UniqueNo
                            join role in Constant.Sys_Role_List on ru.Role_Id equals role.Id
                            select new UserModel
                            {
                                Num = 0,
                                UniqueNo = user.UniqueNo,
                                Name = user.Name,
                                Sex = user.Sex,
                                DepartmentID = user.Major_ID,
                                DepartmentName = user.DepartmentName,
                                SubDepartmentName = user.SubDepartmentName,
                                ClassID = stu_ != null ? stu_.ClassNo : "",
                                ClassName = stu_ != null ? stu_.ClassName : "",
                            }).ToList();

                var data = new
                {
                    DPList = (from q in list
                              where q.DepartmentName != ""
                              select new DPModel()
                              {
                                  Major_ID = q.DepartmentID,
                                  DepartmentName = q.DepartmentName,
                              }).Distinct(new DPModelComparer()),
                    ClsList = (from q in list where q.ClassID != "" select new ClsModel() { ClassID = q.ClassID, ClassName = q.ClassName, Major_ID = q.DepartmentID }).Distinct(new ClsModelComparer()),
                };

                jsm = JsonModel.get_jsonmodel(intSuccess, "success", data);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return jsm;
        }


        #endregion
    }
}