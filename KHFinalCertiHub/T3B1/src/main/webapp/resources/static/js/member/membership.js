window.onload = function(){ 
    const idInput = document.querySelector("#membershipForm input[name = memberId]");
    const nicknameInput = document.querySelector("#membershipForm input[name = memberNickname]");
    const memberpwdInput = document.querySelector("#membershipForm input[name = memberPwd]");
    const checkpwdInput = document.querySelector("#membershipForm input[name = checkPwd]");
    let eventFlag;

    idInput.onkeyup = function(ev) { // 키가 입력 될때마다 호출
    
        clearTimeout(eventFlag); // 아직 실행되지 않은 ajax요청을 취소

        const str = ev.target.value;
        if(str.trim().length >= 5) {
            eventFlag = setTimeout(function(){ // 1초 뒤에 값을 확인 후 ajax 요청
                // ajax 요청
                $.ajax({
                    url:"idCheck.me",
                    data: {checkId: str},
                    success : function(result){
                        const checkResultId = document.querySelector("#checkResultId");
                        checkResultId.style.display = "block";

                        if(result === "NNNNN"){
                            checkResultId.style.color ="#83c5be";
                            checkResultId.innerText = "이미 사용중인 아이디입니다.";

                        }else {
                            checkResultId.style.color = "#006d77";
                            checkResultId.innerText = "사용 가능한 아이디입니다.";

                        }
                    }, error : function() {
                        console.log("아이디 중복 체크 ajax 실패")
                    }
                })
            }, 1000)
        }else {
            document.querySelector("#checkResultId").style.display = "none";
        }
    }

    nicknameInput.onkeyup = function(ev) {

        clearTimeout(eventFlag);

        const str = ev.target.value;
        if(str.trim().length >=5) {
            eventFlag = setTimeout(function(){
                $.ajax({
                    url:"nicknameCheck.me",
                    data: {checknickName: str},
                    success : function(result){
                        const checkResultnickName = document.querySelector("#checkResultnickName");
                        checkResultnickName.style.display = "block";

                        if(result === "NN"){
                            checkResultnickName.style.color = "#83c5be";
                            checkResultnickName.innerText = "이미 사용중인 닉네임입니다.";

                        }else {
                            checkResultnickName.style.color = "#006d77";
                            checkResultnickName.innerText = "사용 가능한 닉네임입니다.";
                        }
                    }, error : function() {
                        console.log("닉네임 중복 체크 ajax 실패")
                    }
                })
            }, 1000)
        }else {
            document.querySelector("#checkResultnickName").style.display = "none";
        }
    }  
    
    checkpwdInput.onkeyup = function() {
        console.log(onkeyup);
        const memberPwd = memberpwdInput.value;
        const checkPwd = checkpwdInput.value;

        const checkResultPwd = document.querySelector("#checkResultPwd");

        if(memberPwd && checkPwd) {
            if(memberPwd === checkPwd) {
                checkResultPwd.style.display = "block";
                checkResultPwd.style.color = "#006d77";
                checkResultPwd.innerText = "비밀번호가 일치합니다.";
            }else {
                checkResultPwd.style.display = "block";
                checkResultPwd.style.color = "#83c5be";
                checkResultPwd.innerText = "비밀번호가 일치하지 않습니다.";
            }
        } else {
            checkResultPwd.style.display = "none";
        }
    }
}