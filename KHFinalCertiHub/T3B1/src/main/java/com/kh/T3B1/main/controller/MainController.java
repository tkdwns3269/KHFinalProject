package com.kh.T3B1.main.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.T3B1.community.model.vo.Board;
import com.kh.T3B1.main.model.service.MainService;

@Controller
public class MainController {
	
	private MainService MainService;
	
	@Autowired
	public MainController(MainService mainService) {
		this.MainService = mainService;
	}
	
	@RequestMapping("main")
	public String mainPage(Model m) {
		List<Board> topPosts = MainService.getTopPostsByViews(5);
		List<Board> latestNotices = MainService.getLatestNotices(5);
		
		m.addAttribute("topPosts", topPosts);
		m.addAttribute("latestNotices", latestNotices);
		return "main/mainPage";
	}

}
