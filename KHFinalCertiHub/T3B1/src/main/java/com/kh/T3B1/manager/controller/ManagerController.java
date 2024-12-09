package com.kh.T3B1.manager.controller;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.kh.T3B1.common.template.Template;
import com.kh.T3B1.common.vo.PageInfo;
import com.kh.T3B1.common.vo.SearchOption;
import com.kh.T3B1.community.model.vo.Board;
import com.kh.T3B1.manager.service.ManagerService;
import com.kh.T3B1.member.model.vo.Member;
import com.kh.T3B1.personal.model.vo.License2;
import com.kh.T3B1.study.model.vo.StudyBoard;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/manager")
public class ManagerController {
	
	private final ManagerService managerService;
	
	@Autowired
	public ManagerController(ManagerService managerService) {
		this.managerService = managerService;
	}
	
	@RequestMapping("manager")
	public String managerPage(@RequestParam(value="cpage",defaultValue="1")int currentPage, Model m) {
		int managerboardCount = managerService.managerListCount();
		
		PageInfo pi = Template.getPageInfo(managerboardCount, currentPage, 1, 1);
		ArrayList<Board> list = managerService.managerList(pi);
		System.out.println("list :" + list);
		System.out.print("pi :" + pi);
		m.addAttribute("list", list);
		m.addAttribute("pi", pi);
		m.addAttribute("pageName","managerPage");
		return "manager/manager";
	}
	
	@RequestMapping("certify")
	public String certifyPage(Model m) {
		m.addAttribute("pageName","certifyPage");
		return "manager/certify";
	}
	
	@RequestMapping("commulist")
	public String commulistPage(@RequestParam(value = "keyword", defaultValue = "")String keyword,
			@RequestParam(value = "cpage", defaultValue = "1")int currentPage,Model m) {
		
		//검색 결과의 총 갯수 조회
		int commulistCount = managerService.Countcommulist(keyword);
		
		// 페이지 정보 객체 생성(현재 페이지, 총 검색 갯수, 한 페이지당 항목 수, 페이지 범위)
		PageInfo pi = Template.getPageInfo(commulistCount, currentPage, 10, 10);
		
		// 검색 결과 목록 조회
		ArrayList<Board> list = managerService.CommuList(pi, keyword);
		
		// 모델에 데이터를 추가
		m.addAttribute("list", list);
		m.addAttribute("pi", pi);
		m.addAttribute("keyword", keyword);
		m.addAttribute("pageName","commulistPage");
		return "manager/commulist";
	}
	
	@RequestMapping("list")
	public String listPage(@RequestParam(value = "keyword", defaultValue = "")String keyword,
			@RequestParam(value = "cpage", defaultValue = "1")int currentPage,Model m) {
		// 검색 결과의 총 갯수 조회
		int studylistCount = managerService.Countstudylist(keyword);
		
		// 페이지 정보 객체 생성(현재 페이지, 총 검색 개수, 한 페이지당 항목 수, 페이지 범위)
		PageInfo pi = Template.getPageInfo(studylistCount, currentPage, 10, 10);
		
		// 검색 결과 목록 조회
		ArrayList<StudyBoard> list = managerService.StudyList(pi, keyword);
		
		// 모델에 데이터를 추가
		m.addAttribute("list", list);		
		m.addAttribute("pi", pi);		
		m.addAttribute("keyword", keyword);		
		m.addAttribute("pageName","listPage");
		
		// 검색 페이지로 이동
		return "manager/list";
	}
	
	@RequestMapping("report")
	public String reportPage(Model m) {
		m.addAttribute("pageName", "reportPage");
		return "manager/report";
	}
	
	@RequestMapping("user")
	public String userPage(@RequestParam(value = "keyword", defaultValue = "")String keyword,
			@RequestParam(value = "cpage", defaultValue = "1")int currentPage,Model m) {
		// 검색 결과의 총 갯수 조회
		int userCount = managerService.CountUser(keyword);
		
		// 페이지 정보 객체 생성(현재 페이지, 총 검색 개수, 한 페이지당 항목 수, 페이지 범위)
		PageInfo pi = Template.getPageInfo(userCount, currentPage, 10, 10);
		
		// 검색 결과 목록 조회
		ArrayList<Member> list = managerService.selectUserList(pi, keyword);
		// 모델에 데이터를 추가
		m.addAttribute("list", list); // 검색 결과 목록
		m.addAttribute("pi", pi); // 페이징 정보
		m.addAttribute("keyword", keyword); // 검색 키워드
		m.addAttribute("pageName","userPage");
		
		// 검색 페이지로 이동
		return "manager/user";
	}
	
	@ResponseBody
	@PostMapping(value="licenseList", produces="application/json; charset=UTF-8")
	public String selectLicenseList(int currentPage, int boardLimit, int pageLimit, String keyword) {
		// 요청 한번에 불러올 게시글의 수, 최대 20개 까지
		pageLimit = pageLimit <= 20 ? pageLimit : 20;
		
		// 이미 마지막 게시판 페이지라면 DB에서 조회하지 않도록 막아준다
		int listCount = managerService.countLicenseList(keyword);
		if((currentPage - 1) * pageLimit > listCount) {
			return null;
		}
		
		PageInfo pi = Template.getPageInfo(listCount, currentPage, pageLimit, boardLimit);
		
		// 검색 옵션 저장
		SearchOption so = new SearchOption();
		if(keyword != null && !keyword.equals("")) so.setKeyword(keyword);
		
		ArrayList<License2> licenseList = managerService.selectLicenseList(pi, so);
		
		log.info("\nlicenseList : {}\n", licenseList);
		
		HashMap<String, String> jsonData =  new HashMap<>();
		jsonData.put("board", new Gson().toJson(licenseList));
		jsonData.put("pageInfo", new Gson().toJson(pi));
		
		return new Gson().toJson(jsonData);
	}
	
	@ResponseBody
	@PostMapping(value="reportList", produces="application/json; charset=UTF-8")
	public String selectReportList(int currentPage, int boardLimit, int pageLimit, String keyword) {
		// 요청 한번에 불러올 게시글의 수, 최대 20개 까지
		pageLimit = pageLimit <= 20 ? pageLimit : 20;
		
		// 이미 마지막 게시판 페이지라면 DB에서 조회하지 않도록 막아준다
		int listCount = managerService.countReportList(keyword);
		if((currentPage - 1) * pageLimit > listCount) {
			return null;
		}
		
		PageInfo pi = Template.getPageInfo(listCount, currentPage, pageLimit, boardLimit);
		
		// 검색 옵션 저장
		SearchOption so = new SearchOption();
		if(keyword != null && !keyword.equals("")) so.setKeyword(keyword);
		
		ArrayList<License2> licenseList = managerService.selectLicenseList(pi, so);
		
		log.info("\nlicenseList : {}\n", licenseList);
		
		HashMap<String, String> jsonData =  new HashMap<>();
		jsonData.put("board", new Gson().toJson(licenseList));
		jsonData.put("pageInfo", new Gson().toJson(pi));
		
		return new Gson().toJson(jsonData);
	}
}
