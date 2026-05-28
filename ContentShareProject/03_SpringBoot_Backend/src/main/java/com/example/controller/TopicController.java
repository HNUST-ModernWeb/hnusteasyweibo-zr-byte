package com.example.controller;

import com.example.entity.Topic;
import com.example.service.TopicService;
import com.example.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/topic")
@CrossOrigin
public class TopicController {

    @Autowired
    private TopicService topicService;

    @PostMapping
    public Result<Topic> createTopic(@RequestBody Topic topic) {
        return topicService.createTopic(topic);
    }

    @GetMapping("/{topicId}")
    public Result<Topic> getTopicById(@PathVariable Long topicId) {
        return topicService.getTopicById(topicId);
    }

    @GetMapping("/name/{name}")
    public Result<Topic> getTopicByName(@PathVariable String name) {
        return topicService.getTopicByName(name);
    }

    @GetMapping("/hot")
    public Result<List<Topic>> getHotTopics(@RequestParam(defaultValue = "20") Integer limit) {
        return topicService.getHotTopics(limit);
    }

    @GetMapping("/recommend")
    public Result<List<Topic>> getRecommendTopics() {
        return topicService.getRecommendTopics();
    }

    @GetMapping("/category/{category}")
    public Result<List<Topic>> getTopicsByCategory(@PathVariable String category) {
        return topicService.getTopicsByCategory(category);
    }

    @GetMapping("/search")
    public Result<List<Topic>> searchTopics(@RequestParam String keyword) {
        return topicService.searchTopics(keyword);
    }
}
